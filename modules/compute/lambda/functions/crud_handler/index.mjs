import {
    make_response
} from '/opt/nodejs/helper.mjs';

export const handler= async (event) => {
    try {
        console.log("hello world");
        make_response(200, {
            "message": "Successful"
        });
    } catch (error) {
        console.log(error?.message || error);
        make_response(500, {
            "message": "Internal server error",
            "detail": error?.message || error
        });
    }
}