const default_headers = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",          // change for production
    "Access-Control-Allow-Credentials": true
}

function make_request(status_code, body = null, headers = {}) {
    return {
        status_code,
        headers: { ...default_headers, ...headers },
        body: body === null ? "" : (typeof body === "string" ? body : JSON.stringify(body))
    }
}

module.exports = { make_request };