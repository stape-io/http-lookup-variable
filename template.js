const encodeUriComponent = require('encodeUriComponent');
const getTimestampMillis = require('getTimestampMillis');
const getType = require('getType');
const JSON = require('JSON');
const Promise = require('Promise');
const sendHttpRequest = require('sendHttpRequest');
const sha256Sync = require('sha256Sync');
const templateDataStorage = require('templateDataStorage');
const makeInteger = require('makeInteger');
const makeString = require('makeString');
const makeTableMap = require('makeTableMap');

/*==============================================================================
===============================================================================*/

let requestHeaders = {};
let requestBody = {};
const version = '1.0.7';

if (data.requestMethod !== 'GET') {
  requestHeaders =
    data.requestType === 'json'
      ? { 'Content-Type': 'application/json' }
      : { 'Content-Type': 'application/x-www-form-urlencoded' };

  if (data.data) {
    let postBodyCustomData =
      data.simpleObject || data.requestType !== 'json'
        ? createSimpleObject()
        : createNestedObject();

    for (let key in postBodyCustomData) {
      requestBody[key] = postBodyCustomData[key];
    }
  }
}

if (data.headers) {
  for (let key in data.headers) {
    requestHeaders[data.headers[key].key] = data.headers[key].value;
  }
}

if (data.insideArray && data.requestType === 'json') {
  requestBody = [requestBody];
}

let postBody = null;
const requestOptions = { headers: requestHeaders, method: data.requestMethod };

if (data.requestMethod !== 'GET') {
  if (data.requestType === 'json') {
    postBody = JSON.stringify(requestBody);
  }

  if (data.requestType === 'form') {
    let firstKey = true;
    postBody = '';

    for (let key in requestBody) {
      if (firstKey) {
        firstKey = false;
      } else {
        postBody += '&';
      }

      postBody += enc(key) + '=' + enc(requestBody[key]);
    }
  }
}

if (data.requestTimeout) {
  requestOptions.timeout = makeInteger(data.requestTimeout);
}

return sendRequest(data.url, requestOptions, postBody).then(mapResponse);

/*==============================================================================
  Vendor related functions
==============================================================================*/

function sendRequest(url, requestOptions, postBody) {
  const cacheKey = sha256Sync(
    version + url + JSON.stringify(requestOptions) + postBody + data.jsonParseKeyName
  );
  const cacheTimeKey = cacheKey + '_timestamp';
  const timeNow = getTimestampMillis();

  if (data.storeResponse) {
    let cachedBody = templateDataStorage.getItemCopy(cacheKey);
    const cachedBodyTimestamp = templateDataStorage.getItemCopy(cacheTimeKey);
    if (data.expirationTime) {
      const expirationTime = makeInteger(data.expirationTime) * 3600000;

      if (cachedBodyTimestamp && timeNow - makeInteger(cachedBodyTimestamp) >= expirationTime) {
        cachedBody = '';
        templateDataStorage.removeItem(cacheKey);
        templateDataStorage.removeItem(cacheTimeKey);
      }
    }

    if (cachedBody) return Promise.create((resolve) => resolve(cachedBody));
  }

  return sendHttpRequest(url, requestOptions, postBody)
    .then((successResult) => {
      const statusCode = successResult.statusCode;

      if (statusCode === 301 || statusCode === 302) {
        return sendRequest(successResult.headers.location, requestOptions, postBody);
      }

      if (data.storeResponse && statusCode >= 200 && statusCode < 300) {
        templateDataStorage.setItemCopy(cacheKey, successResult.body);
        templateDataStorage.setItemCopy(cacheTimeKey, timeNow);
      }
      return successResult.body;
    })
    .catch(() => {});
}

/*==============================================================================
  Helpers
==============================================================================*/

function mapResponse(bodyString) {
  if (!data.jsonParse || !bodyString) return bodyString;
  const parsedBody = JSON.parse(bodyString);
  if (data.jsonParseKey) {
    return data.jsonParseKeyName.split('.').reduce(function (obj, key) {
      if (obj === undefined) return undefined;
      if (obj.hasOwnProperty(key)) return obj[key];
      return undefined;
    }, parsedBody);
  }
  return parsedBody;
}

function createSimpleObject() {
  return makeTableMap(data.data, 'key', 'value');
}

function mergeObjects() {
  let obj = {},
    i = 0,
    il = arguments.length,
    key;
  for (; i < il; i++) {
    for (key in arguments[i]) {
      if (arguments[i][key]) {
        obj[key] = arguments[i][key];
      }
    }
  }
  return obj;
}

function createNestedObject() {
  let object = {};

  for (let key in data.data) {
    let dotPath = data.data[key].key;
    let rootProperty = dotPath.split('.')[0];
    let strObj = strToObj(dotPath, data.data[key].value)[rootProperty];

    if (object[rootProperty]) {
      object[rootProperty] = mergeObjects(object[rootProperty], strObj);
    } else {
      object[rootProperty] = strObj;
    }
  }

  return object;
}

function strToObj(dotPath, val) {
  let i,
    obj = {},
    dotArr = dotPath.split('.');
  let x = obj;

  for (i = 0; i < dotArr.length - 1; i++) {
    x = x[dotArr[i]] = {};
  }

  x[dotArr[i]] = val;

  return obj;
}

function enc(data) {
  if (['null', 'undefined'].indexOf(getType(data)) !== -1) data = '';
  return encodeUriComponent(makeString(data));
}
