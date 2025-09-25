const default_headers = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",          // change for production
    "Access-Control-Allow-Credentials": true
}

export const make_respones = (status_code, body = null, headers = {}) => {

    console.log(status_code)
    console.log(body)
    return {
        statusCode: status_code,
        headers: { ...default_headers, ...headers },
        body: body === null ? "" : (typeof body === "string" ? body : JSON.stringify(body))
    }
}