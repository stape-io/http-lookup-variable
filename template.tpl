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
    "name": "jsonParse",
    "checkboxText": "Parse response as JSON",
    "simpleValueType": true,
    "subParams": [
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
            ],
            "help": "Specify the value of a specific key whose value you want to return. Use dot notation if needed (e.g. \u003ci\u003efoo.id\u003c/i\u003e, \u003ci\u003ebar.0.price\u003c/i\u003e)."
          }
        ]
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "storeResponse",
    "checkboxText": "Store response in cache",
    "simpleValueType": true,
    "help": "Store the response in Template Storage. If all parameters of the request are the same response will be taken from the cache if it exists.",
    "subParams": [
      {
        "type": "TEXT",
        "name": "expirationTime",
        "displayName": "Cache Expiration Time",
        "simpleValueType": true,
        "help": "It will update the cache if data is expired.",
        "enablingConditions": [
          {
            "paramName": "storeResponse",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "valueValidators": [
          {
            "type": "POSITIVE_NUMBER"
          },
          {
            "type": "NON_EMPTY"
          }
        ],
        "defaultValue": 12,
        "valueUnit": "hours"
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
        "checkboxText": "Put request object inside an array",
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

scenarios:
- name: JSON Response - Entire reponse is correctly extracted without specifying a
    key
  code: |-
    mockData.jsonParseKey = undefined;

    const expectedResponseBody = { foo: { bar: [{ abc: '456' }, { cde: 123 }] }, test: 'example' };
    const expectedStringifiedResponseBody = JSON.stringify(expectedResponseBody);

    mock('sendHttpRequest', () => {
      return Promise.create((resolve) =>
        resolve({ statusCode: 200, headers: {}, body: expectedStringifiedResponseBody })
      );
    });

    runCode(mockData).then((result) => {
      assertThat(result).isEqualTo(expectedResponseBody);
    });
- name: JSON Response - Top-level key is correctly extracted from response
  code: |-
    mockData.jsonParseKey = true;
    mockData.jsonParseKeyName = 'test';

    const expectedResponseBody = { foo: { bar: [{ abc: '456' }, { cde: 123 }] }, test: 'example' };
    const expectedStringifiedResponseBody = JSON.stringify(expectedResponseBody);

    mock('sendHttpRequest', () => {
      return Promise.create((resolve) =>
        resolve({ statusCode: 200, headers: {}, body: expectedStringifiedResponseBody })
      );
    });

    runCode(mockData).then((result) => {
      assertThat(result).isEqualTo('example');
    });
- name: JSON Response - Dot notation key is correctly extracted from response
  code: |-
    mockData.jsonParseKey = true;
    mockData.jsonParseKeyName = 'foo.bar.0.abc';

    const expectedResponseBody = { foo: { bar: [{ abc: '456' }, { cde: 123 }] }, test: 'example' };
    const expectedStringifiedResponseBody = JSON.stringify(expectedResponseBody);

    mock('sendHttpRequest', () => {
      return Promise.create((resolve) =>
        resolve({ statusCode: 200, headers: {}, body: expectedStringifiedResponseBody })
      );
    });

    runCode(mockData).then((result) => {
      assertThat(result).isEqualTo('456');
    });
- name: Raw String Response Passes Through When JSON Parsing Is Disabled
  code: |-
    mockData.jsonParse = false;

    mock('sendHttpRequest', () => {
      return Promise.create((resolve) =>
        resolve({ statusCode: 200, headers: {}, body: 'plain text response' })
      );
    });

    runCode(mockData).then((result) => {
      assertThat(result).isEqualTo('plain text response');
    });
- name: Redirect Responses Are Followed To The New Location
  code: |-
    mockData.jsonParse = false;

    let requestCount = 0;
    mock('sendHttpRequest', (requestUrl) => {
      requestCount++;
      if (requestCount === 1) {
        assertThat(requestUrl).isEqualTo('https://example.com');
        return Promise.create((resolve) =>
          resolve({
            statusCode: 302,
            headers: { location: 'https://example.com/redirected' },
            body: ''
          })
        );
      }
      assertThat(requestUrl).isEqualTo('https://example.com/redirected');
      return Promise.create((resolve) =>
        resolve({ statusCode: 200, headers: {}, body: 'redirected response' })
      );
    });

    runCode(mockData).then((result) => {
      assertThat(requestCount).isEqualTo(2);
      assertThat(result).isEqualTo('redirected response');
    });
- name: Cache Is Reused When No Expiration Time Is Configured
  code: |-
    mockData.jsonParse = false;
    mockData.storeResponse = true;

    let requestCount = 0;
    mock('sendHttpRequest', () => {
      requestCount++;
      return Promise.create((resolve) =>
        resolve({ statusCode: 200, headers: {}, body: 'fresh response' })
      );
    });

    const storage = {};
    mockObject('templateDataStorage', {
      getItemCopy: (key) => (storage.hasOwnProperty(key) ? storage[key] : null),
      setItemCopy: (key, value) => {
        storage[key] = value;
      },
      removeItem: (key) => {
        storage[key] = null;
      }
    });

    runCode(mockData).then((firstResult) => {
      return runCode(mockData).then((secondResult) => {
        assertThat(requestCount).isEqualTo(1);
        assertThat(firstResult).isEqualTo('fresh response');
        assertThat(secondResult).isEqualTo('fresh response');
      });
    });
- name: Cache Is Reused Within The Configured Expiration Window
  code: |-
    mockData.jsonParse = false;
    mockData.storeResponse = true;
    mockData.expirationTime = 12;

    let requestCount = 0;
    mock('sendHttpRequest', () => {
      requestCount++;
      return Promise.create((resolve) =>
        resolve({ statusCode: 200, headers: {}, body: 'cached response' })
      );
    });

    const storage = {};
    mockObject('templateDataStorage', {
      getItemCopy: (key) => (storage.hasOwnProperty(key) ? storage[key] : null),
      setItemCopy: (key, value) => {
        storage[key] = value;
      },
      removeItem: (key) => {
        storage[key] = null;
      }
    });

    const baseTime = 1700000000000;
    mock('getTimestampMillis', () => baseTime);

    runCode(mockData).then(() => {
      // 11 hours later, still inside the 12 hour window.
      mock('getTimestampMillis', () => baseTime + 11 * 3600000);

      return runCode(mockData).then((secondResult) => {
        assertThat(requestCount).isEqualTo(1);
        assertThat(secondResult).isEqualTo('cached response');
      });
    });
- name: Cache Expires After The Configured Expiration Window
  code: |-
    mockData.jsonParse = false;
    mockData.storeResponse = true;
    mockData.expirationTime = 12;

    let requestCount = 0;
    mock('sendHttpRequest', () => {
      requestCount++;
      const body = requestCount === 1 ? 'cached response' : 'refreshed response';
      return Promise.create((resolve) => resolve({ statusCode: 200, headers: {}, body: body }));
    });

    const storage = {};
    mockObject('templateDataStorage', {
      getItemCopy: (key) => (storage.hasOwnProperty(key) ? storage[key] : null),
      setItemCopy: (key, value) => {
        storage[key] = value;
      },
      removeItem: (key) => {
        storage[key] = null;
      }
    });

    const baseTime = 1700000000000;
    mock('getTimestampMillis', () => baseTime);

    runCode(mockData).then(() => {
      // 13 hours later, past the 12 hour window.
      mock('getTimestampMillis', () => baseTime + 13 * 3600000);

      return runCode(mockData).then((secondResult) => {
        assertThat(requestCount).isEqualTo(2);
        assertThat(secondResult).isEqualTo('refreshed response');
      });
    });
- name: Non Success Status Code Response Is Not Cached
  code: |-
    mockData.jsonParse = false;
    mockData.storeResponse = true;

    let requestCount = 0;
    mock('sendHttpRequest', () => {
      requestCount++;
      return Promise.create((resolve) =>
        resolve({ statusCode: 500, headers: {}, body: 'server error' })
      );
    });

    const storage = {};
    mockObject('templateDataStorage', {
      getItemCopy: (key) => (storage.hasOwnProperty(key) ? storage[key] : null),
      setItemCopy: (key, value) => {
        storage[key] = value;
      },
      removeItem: (key) => {
        storage[key] = null;
      }
    });

    runCode(mockData).then((firstResult) => {
      return runCode(mockData).then((secondResult) => {
        assertThat(requestCount).isEqualTo(2);
        assertThat(firstResult).isEqualTo('server error');
        assertThat(secondResult).isEqualTo('server error');
      });
    });
- name: POST Request With JSON Body Uses Dot Notation To Build A Nested Object
  code: |-
    mockData.requestMethod = 'POST';
    mockData.requestType = 'json';
    mockData.jsonParse = false;
    mockData.data = [
      { key: 'user.id', value: '123' },
      { key: 'user.name', value: 'Jane' },
      { key: 'flag', value: 'true' }
    ];

    mock('sendHttpRequest', (requestUrl, requestOptions, requestBody) => {
      assertThat(requestOptions.method).isEqualTo('POST');
      assertThat(requestOptions.headers['Content-Type']).isEqualTo('application/json');
      assertThat(JSON.parse(requestBody)).isEqualTo({
        user: { id: '123', name: 'Jane' },
        flag: 'true'
      });
      return Promise.create((resolve) => resolve({ statusCode: 200, headers: {}, body: 'ok' }));
    });

    runCode(mockData).then((result) => {
      assertThat(result).isEqualTo('ok');
    });
- name: POST Request With JSON Body And Simple Object Flag Keeps Flat Keys
  code: |-
    mockData.requestMethod = 'POST';
    mockData.requestType = 'json';
    mockData.jsonParse = false;
    mockData.simpleObject = true;
    mockData.data = [{ key: 'user.id', value: '123' }];

    mock('sendHttpRequest', (requestUrl, requestOptions, requestBody) => {
      assertThat(JSON.parse(requestBody)).isEqualTo({ 'user.id': '123' });
      return Promise.create((resolve) => resolve({ statusCode: 200, headers: {}, body: 'ok' }));
    });

    runCode(mockData).then((result) => {
      assertThat(result).isEqualTo('ok');
    });
- name: POST Request With JSON Body Inside An Array
  code: |-
    mockData.requestMethod = 'POST';
    mockData.requestType = 'json';
    mockData.jsonParse = false;
    mockData.insideArray = true;
    mockData.data = [{ key: 'id', value: '1' }];

    mock('sendHttpRequest', (requestUrl, requestOptions, requestBody) => {
      assertThat(JSON.parse(requestBody)).isEqualTo([{ id: '1' }]);
      return Promise.create((resolve) => resolve({ statusCode: 200, headers: {}, body: 'ok' }));
    });

    runCode(mockData).then((result) => {
      assertThat(result).isEqualTo('ok');
    });
- name: PUT Request With Form Data Body Is Url Encoded
  code: |-
    mockData.requestMethod = 'PUT';
    mockData.requestType = 'form';
    mockData.jsonParse = false;
    mockData.data = [
      { key: 'a', value: '1' },
      { key: 'b', value: 'x y' }
    ];

    mock('sendHttpRequest', (requestUrl, requestOptions, requestBody) => {
      assertThat(requestOptions.method).isEqualTo('PUT');
      assertThat(requestOptions.headers['Content-Type']).isEqualTo('application/x-www-form-urlencoded');
      assertThat(requestBody).isEqualTo('a=1&b=x%20y');
      return Promise.create((resolve) => resolve({ statusCode: 200, headers: {}, body: 'ok' }));
    });

    runCode(mockData).then((result) => {
      assertThat(result).isEqualTo('ok');
    });
- name: Custom Headers Are Merged Into The Request And Can Override Defaults
  code: |-
    mockData.requestMethod = 'POST';
    mockData.requestType = 'json';
    mockData.jsonParse = false;
    mockData.headers = [
      { key: 'X-Api-Key', value: 'secret' },
      { key: 'Content-Type', value: 'application/vnd.api+json' }
    ];

    mock('sendHttpRequest', (requestUrl, requestOptions, requestBody) => {
      assertThat(requestOptions.headers['X-Api-Key']).isEqualTo('secret');
      assertThat(requestOptions.headers['Content-Type']).isEqualTo('application/vnd.api+json');
      return Promise.create((resolve) => resolve({ statusCode: 200, headers: {}, body: 'ok' }));
    });

    runCode(mockData).then((result) => {
      assertThat(result).isEqualTo('ok');
    });
- name: Request Timeout Option Is Applied When Provided
  code: |-
    mockData.jsonParse = false;
    mockData.requestTimeout = '5000';

    mock('sendHttpRequest', (requestUrl, requestOptions) => {
      assertThat(requestOptions.timeout).isEqualTo(5000);
      return Promise.create((resolve) => resolve({ statusCode: 200, headers: {}, body: 'ok' }));
    });

    runCode(mockData).then((result) => {
      assertThat(result).isEqualTo('ok');
    });
- name: Missing JSON Parse Key Returns Undefined
  code: |-
    mockData.jsonParseKey = true;
    mockData.jsonParseKeyName = 'missing.path';

    const responseBody = JSON.stringify({ foo: 'bar' });

    mock('sendHttpRequest', () => {
      return Promise.create((resolve) => resolve({ statusCode: 200, headers: {}, body: responseBody }));
    });

    runCode(mockData).then((result) => {
      assertThat(result).isEqualTo(undefined);
    });
- name: Request Failure Resolves To Undefined When JSON Parsing Is Enabled
  code: |-
    mockData.jsonParse = true;

    mock('sendHttpRequest', () => {
      return Promise.create((resolve, reject) => reject({ reason: 'failed' }));
    });

    runCode(mockData).then((result) => {
      assertThat(result).isEqualTo(undefined);
    });
- name: Request Failure Resolves To Undefined When JSON Parsing Is Disabled
  code: |-
    mockData.jsonParse = false;

    mock('sendHttpRequest', () => {
      return Promise.create((resolve, reject) => reject({ reason: 'failed' }));
    });

    runCode(mockData).then((result) => {
      assertThat(result).isEqualTo(undefined);
    });
- name: Empty Response Body Is Returned As Is When JSON Parsing Is Enabled
  code: |-
    mockData.jsonParse = true;

    mock('sendHttpRequest', () => {
      return Promise.create((resolve) => resolve({ statusCode: 200, headers: {}, body: '' }));
    });

    runCode(mockData).then((result) => {
      assertThat(result).isEqualTo('');
    });
setup: |-
  const JSON = require('JSON');
  const Promise = require('Promise');

  const mockData = {
    requestMethod: 'GET',
    url: 'https://example.com',
    jsonParse: true
  };


___NOTES___

2026-09-16 - Change Notes:
  - Fix cache expiration time being calculated 10x too short (wrong ms conversion factor) and skip caching non-2xx responses; bump version to 1.0.7
  - Guard response parsing against empty/failed request bodies so a failed or empty request resolves safely instead of throwing
  - Reorganize template parameters (cache expiration under Store Response, key extraction under Parse Response, dot-notation/array options under Request Data) with minor help text wording updates
  - Add comprehensive unit test coverage for caching, redirects, request building, and failure paths

2026-05-21 Change Notes:
 - Console logging removal.

Created on 11/08/2022, 15:18:11

