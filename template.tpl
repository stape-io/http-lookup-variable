___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "HTTP Lookup",
  "description": "Send JSON or Form-Data request to your URL and parse the response as JSON or string.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "requestMethod",
    "displayName": "Request Method",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "GET",
        "displayValue": "GET"
      },
      {
        "value": "POST",
        "displayValue": "POST"
      },
      {
        "value": "PUT",
        "displayValue": "PUT"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "GET",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "alwaysInSummary": true
  },
  {
    "type": "SELECT",
    "name": "requestType",
    "displayName": "Request Method",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "json",
        "displayValue": "JSON"
      },
      {
        "value": "form",
        "displayValue": "Form-Data"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "json",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "requestMethod",
        "paramValue": "GET",
        "type": "NOT_EQUALS"
      }
    ],
    "alwaysInSummary": true
  },
  {
    "type": "TEXT",
    "name": "url",
    "displayName": "Destination URL",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "valueHint": "https://"
  },
  {
    "type": "CHECKBOX",
    "name": "simpleObject",
    "checkboxText": "Do not use dot notation",
    "simpleValueType": true,
    "help": "By default, you can use dot notation to create a nested request object. \nBut in case you need to create a property that contains a dot then you can use this option for that.",
    "enablingConditions": [
      {
        "paramName": "requestType",
        "paramValue": "json",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "insideArray",
    "checkboxText": "Put request object inside the array.",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "requestType",
        "paramValue": "json",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "jsonParse",
    "checkboxText": "Parse response as JSON",
    "simpleValueType": true
  },
  {
    "type": "CHECKBOX",
    "name": "storeResponse",
    "checkboxText": "Store response in cache",
    "simpleValueType": true,
    "help": "Store the response in Template Storage. If all parameters of the request are the same response will be taken from the cache if it exists."
  },
  {
    "type": "CHECKBOX",
    "name": "jsonParseKey",
    "checkboxText": "Extract key from JSON object",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "jsonParse",
        "paramValue": true,
        "type": "EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "TEXT",
        "name": "jsonParseKeyName",
        "displayName": "Key Name",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "jsonParseKey",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "requestData",
    "displayName": "Request Data",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "LABEL",
        "name": "start",
        "displayName": "{",
        "enablingConditions": [
          {
            "paramName": "requestType",
            "paramValue": "json",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "data",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Property",
            "name": "key",
            "type": "TEXT",
            "isUnique": true
          },
          {
            "defaultValue": "",
            "displayName": "Value",
            "name": "value",
            "type": "TEXT"
          }
        ],
        "newRowButtonText": "Add Value"
      },
      {
        "type": "LABEL",
        "name": "end",
        "displayName": "}",
        "enablingConditions": [
          {
            "paramName": "requestType",
            "paramValue": "json",
            "type": "EQUALS"
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "requestHeaders",
    "displayName": "Request Headers",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "SIMPLE_TABLE",
        "name": "headers",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Key",
            "name": "key",
            "type": "TEXT",
            "isUnique": true
          },
          {
            "defaultValue": "",
            "displayName": "Value",
            "name": "value",
            "type": "TEXT"
          }
        ],
        "newRowButtonText": "Add Header"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "additionalOption",
    "displayName": "Additional Options",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "TEXT",
        "name": "requestTimeout",
        "displayName": "Request Timeout",
        "simpleValueType": true,
        "defaultValue": 3000,
        "valueValidators": [
          {
            "type": "NON_NEGATIVE_NUMBER"
          }
        ]
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const sendHttpRequest = require('sendHttpRequest');
const makeInteger = require('makeInteger');
const makeTableMap = require('makeTableMap');
const JSON = require('JSON');
const encodeUriComponent = require('encodeUriComponent');
const templateDataStorage = require('templateDataStorage');
const sha256Sync = require('sha256Sync');

let requestHeaders = {};
let requestBody = {};

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

return sendRequest(data.url, requestOptions, postBody);

function sendRequest(url, requestOptions, postBody) {
  let cacheKey = sha256Sync(url + JSON.stringify(requestOptions) + postBody + data.jsonParseKeyName);

  if (data.storeResponse) {
    const cachedBody = templateDataStorage.getItemCopy(cacheKey);

    if (cachedBody) return cachedBody;
  }

  return sendHttpRequest(url, requestOptions, postBody).then((successResult) => {
    if (successResult.statusCode === 301 || successResult.statusCode === 302) {
      return sendRequest(successResult.headers['location'], requestOptions, postBody);
    }

    if (!data.jsonParse) {
      if (data.storeResponse) templateDataStorage.setItemCopy(cacheKey, successResult.body);

      return successResult.body;
    }

    const parsedBody = JSON.parse(successResult.body);
    const result = data.jsonParseKey ? parsedBody[data.jsonParseKeyName] : parsedBody;

    if (data.storeResponse) templateDataStorage.setItemCopy(cacheKey, result);

    return result;
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


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_template_storage",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 11/08/2022, 15:18:11


