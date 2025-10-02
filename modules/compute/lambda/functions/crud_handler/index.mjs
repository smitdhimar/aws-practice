import {
    make_response, 
    get_path_action
} from '/opt/nodejs/helper.mjs';
import {
    health_check,
    create_user,
    get_user,
} from './crud_functions.mjs'
export const handler = async (event) => {
    try {
        console.log("🟢 lambda invoked");
        const {
            resource: path,
            httpMethod: http_method,
            body: _body,
            pathParameters: path_parameters,
            queryStringParameters: query_string_parameters
        } = event;
        console.log("path: ", path)
        console.log("http_method: ", http_method)
        console.log("_body: ", _body)
        console.log("path_parameters: ", path_parameters)
        console.log("query_string_parameters: ", query_string_parameters)
        const path_action = get_path_action(http_method, path);
        console.log(path_action)
        const body = _body?.length > 0 ? JSON.parse(_body) : null;

        switch (path_action) {
            case "HEALTH":
                return health_check();
                break;
            case "CREATE_USER":
                return create_user(body);
                break;
            case "GET_USER":
                console.log(path_parameters)
                return get_user(path_parameters?.id)
                break;
            case "UPDATE_USER":
                break;
            case "DELETE_USER":
                return delete_user(path_parameters?.id)
                break;
            default:
                return make_response(404)
                break;
        }

        return make_response(200, {
            "message": "Successful"
        });
    } catch (error) {
        console.log("in catch block")
        console.log(`🔴 ${error?.message || error}`);
        return make_response(500, {
            "message": "Internal server error",
            "detail": `🔴 ${error?.message || error}`
        });
    }
}