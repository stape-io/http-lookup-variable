# HTTP Lookup Variable for Google Tag Manager Server Side

The **HTTP Lookup Variable** for the Google Tag Manager server container lets you make an HTTP request (GET, POST, or PUT) to any URL and use the response as a variable value anywhere in your container — as raw text, a full parsed JSON object, or a single key extracted from it.

## Features

- **Any HTTP method**: GET, POST, or PUT.
- **JSON or Form-Data payloads**: build the request body as a nested JSON object (dot notation), a flat JSON object, or a URL-encoded form body.
- **Custom headers**: attach any additional request headers, overriding the defaults if needed.
- **Response parsing**: return the raw response body, the full parsed JSON object, or a specific key from it (dot notation supported, e.g. `foo.bar.0.id`).
- **Built-in caching**: store responses in Template Storage with a configurable expiration time, to save requests and reduce latency.
- **Redirect following**: `301`/`302` responses are automatically followed.
- **Configurable timeout**: set a custom request timeout.

## How to Use

1. Add the **HTTP Lookup** variable to your GTM Server container from the Template Gallery or by importing the template file.
2. Set the **Request Method** (GET, POST, or PUT) and the **Destination URL**.
3. For POST/PUT requests, choose the **Request Type** (JSON or Form-Data) and add key/value pairs under **Request Data**:
   - Use dot notation in a key (e.g. `user.id`) to build a nested JSON object, or enable **Do not use dot notation** to keep the key literal.
   - Enable **Put request object inside an array** to wrap the payload in a JSON array.
4. Optionally add custom **Request Headers**.
5. Enable **Parse response as JSON** to get a JSON object instead of a raw string, and optionally enable **Extract key from JSON object** to return a specific value (supports dot notation, e.g. `data.items.0.id`).
6. Enable **Store response in cache** to cache identical requests in Template Storage (see [Response Caching](#response-caching) below).
7. Optionally set a custom **Request Timeout** under Additional Options.

## Response Caching

When **Store response in cache** is enabled, the response is cached in Template Storage, keyed by the request (URL, method, headers, body, and the configured JSON key name). Only responses with a `2xx` status code are cached — a failing endpoint never gets "stuck" serving a cached error.

The **Cache Expiration Time** field (in hours) controls how long a cached response is reused before a fresh request is made. Leaving it empty means the cache never expires on its own — it's only invalidated when the request itself changes, or the template version is upgraded.

## Useful Resources

- [HTTP Lookup Variable Solution](https://stape.io/solutions/http-lookup-variable)
- [HTTP Lookup Variable in the Template Gallery](https://tagmanager.google.com/gallery/#/owners/stape-io/templates/http-lookup-variable)

## Open Source

HTTP Lookup Variable for GTM Server Side is developed and maintained by [Stape Team](https://stape.io/) under the Apache 2.0 license.

### GTM Gallery Status
🟢 [Listed](https://tagmanager.google.com/gallery/#/owners/stape-io/templates/http-lookup-variable)
