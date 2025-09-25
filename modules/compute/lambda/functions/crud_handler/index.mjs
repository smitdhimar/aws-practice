import {
    make_respones
} from '/opt/nodejs/helper.mjs';

export const handler= async (event) => {
    try {
        console.log("hello world");

        return make_respones(200, {
            "message": "Successful"
        });
    } catch (error) {
        console.log(error?.message || error);
        return make_respones(500, {
            "message": "Internal server error",
            "detail": error?.message || error
        });
    }
}