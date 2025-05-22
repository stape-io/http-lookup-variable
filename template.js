const sendHttpRequest = require('sendHttpRequest');
const makeInteger = require('makeInteger');
const makeTableMap = require('makeTableMap');
const JSON = require('JSON');
const encodeUriComponent = require('encodeUriComponent');
const templateDataStorage = require('templateDataStorage');
const sha256Sync = require('sha256Sync');
const Promise = require('Promise');
const logToConsole = require('logToConsole');
const getRequestHeader = require('getRequestHeader');
const getContainerVersion = require('getContainerVersion');
const getTimestampMillis = require('getTimestampMillis');

const isLoggingEnabled = determinateIsLoggingEnabled();
const traceId = isLoggingEnabled ? getRequestHeader('trace-id') : undefined;

let requestHeaders = {};
let requestBody = {};
const version = '1.0.6';

if (data.requestMethod !== 'GET') {
  requestHeaders = data.requestType === 'json' ? { 'Content-Type': 'application/json' } : { 'Content-Type': 'application/x-www-form-urlencoded' };

  if (data.data) {
    let postBodyCustomData = data.simpleObject || data.requestType !== 'json' ? createSimpleObject() : createNestedObject();

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
let requestOptions = { headers: requestHeaders, method: data.requestMethod };

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

function sendRequest(url, requestOptions, postBody) {
  let cacheKey = sha256Sync(version + url + JSON.stringify(requestOptions) + postBody + data.jsonParseKeyName);
  let cacheTimeKey = cacheKey + '_timestamp';
  let timeNow = getTimestampMillis();

  if (data.storeResponse) {
    let cachedBody = templateDataStorage.getItemCopy(cacheKey);
    let cachedBodyTimestamp = templateDataStorage.getItemCopy(cacheTimeKey);
    if (data.expirationTime) {
      let expiratoinTimeSeconds = makeInteger(data.expirationTime) * 360000; // convert to miliseconds

      if (cachedBodyTimestamp && timeNow - makeInteger(cachedBodyTimestamp) >= expiratoinTimeSeconds) {
        cachedBody = '';
        templateDataStorage.removeItem(cacheKey);
        templateDataStorage.removeItem(cacheTimeKey);
      }
    }

    if (cachedBody) return Promise.create((resolve) => resolve(cachedBody));
  }
  if (isLoggingEnabled) {
    logToConsole(
      JSON.stringify({
        Name: 'HTTPLookup',
        Type: 'Request',
        TraceId: traceId,
        EventName: 'HttpLookupRequest',
        RequestMethod: data.requestMethod,
        RequestUrl: url,
        RequestBody: postBody
      })
    );
  }

  return sendHttpRequest(url, requestOptions, postBody).then((successResult) => {
    if (isLoggingEnabled) {
      logToConsole(
        JSON.stringify({
          Name: 'HTTPLookup',
          Type: 'Response',
          TraceId: traceId,
          EventName: 'HttpLookupRequest',
          ResponseStatusCode: successResult.statusCode,
          ResponseHeaders: successResult.headers,
          ResponseBody: successResult.body
        })
      );
    }
    if (successResult.statusCode === 301 || successResult.statusCode === 302) {
      return sendRequest(successResult.headers.location, requestOptions, postBody);
    }

    if (data.storeResponse) {
      templateDataStorage.setItemCopy(cacheKey, successResult.body);
      templateDataStorage.setItemCopy(cacheTimeKey, timeNow);
    }
    return successResult.body;
  });
}

function mapResponse(bodyString) {
  if (!data.jsonParse) return bodyString;
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
  data = data || '';
  return encodeUriComponent(data);
}

function determinateIsLoggingEnabled() {
  const containerVersion = getContainerVersion();
  const isDebug = !!(containerVersion && (containerVersion.debugMode || containerVersion.previewMode));

  if (!data.logType) {
    return isDebug;
  }

  if (data.logType === 'no') {
    return false;
  }

  if (data.logType === 'debug') {
    return isDebug;
  }

  return data.logType === 'always';
}
