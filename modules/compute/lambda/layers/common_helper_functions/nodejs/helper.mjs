const default_headers = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",          // change for production
    "Access-Control-Allow-Credentials": true
}

export const make_response = (status_code, body = null, headers = {}) => {
    return {
        statusCode: status_code,
        headers: { ...default_headers, ...headers },
        body: body === null ? "" : (typeof body === "string" ? body : JSON.stringify(body))
    }
}

export const get_path_action = (http_method, path) =>{
    if(!http_method || !path) return "UNKNOWN";
    if(http_method==="GET" || path === '/crud/health') return "HEALTH";
    if(http_method=== "POST" || path === '/crud/user') return "CREATE_USER";
    if(http_method === "GET" || path === '/crud/user/{id}') return "GET_USER";
    if(http_method === "PUT" || path === 'crud/user/{id}') return "UPDATE_USER";
    if(http_method === "DELETE" || path === 'crud/user/{id}') return "DELETE_USER";
}