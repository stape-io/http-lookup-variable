const sendHttpRequest = require('sendHttpRequest');
const makeInteger = require('makeInteger');
const makeTableMap = require('makeTableMap');
const JSON = require('JSON');
const encodeUriComponent = require('encodeUriComponent');

let requestHeaders = {};
let requestBody = {};

if (data.requestMethod !== 'GET') {
    requestHeaders = data.requestType === 'json' ? {'Content-Type': 'application/json'} : {'Content-Type': 'application/x-www-form-urlencoded'};

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
let requestOptions = {headers: requestHeaders, method: data.requestMethod};

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

return sendRequest(data.url, requestOptions, postBody);

function sendRequest(url, requestOptions, postBody) {
    return sendHttpRequest(url, requestOptions, postBody).then((successResult) => {
        if (successResult.statusCode === 301 || successResult.statusCode === 302) {
            return sendRequest(successResult.headers['location'], requestOptions, postBody);
        }

        if (!data.jsonParse) {
            return successResult.body;
        }

        let parsedBody = JSON.parse(successResult.body);

        return data.jsonParseKey ? parsedBody[data.jsonParseKeyName] : parsedBody;
    });
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
    let i, obj = {}, dotArr = dotPath.split('.');
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
