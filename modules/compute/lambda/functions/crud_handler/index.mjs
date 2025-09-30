import {
    make_response, 
    get_path_action
} from '/opt/nodejs/helper.mjs';
import {
    health_check,
    create_user,
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

        const path_action = get_path_action(http_method, path);
        const body = _body.length > 0 ? JSON.parse(_body) : null;

        switch (path_action) {
            case "HEALTH":
                return health_check();
                break;
            case "CREATE_USER":
                return create_user(body);
                break;
            case "GET_USER":
                break;
            case "UPDATE_USER":
                break;
            case "DELETE_USER":
                break;
            default:
                return make_response(404)
                break;
        }

        return make_response(200, {
            "message": "Successful"
        });
    } catch (error) {
        console.log(`🔴 ${error?.message || error}`);
        return make_response(500, {
            "message": "Internal server error",
            "detail": `🔴 ${error?.message || error}`
        });
    }
}