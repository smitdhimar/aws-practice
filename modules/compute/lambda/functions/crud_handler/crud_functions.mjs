import {
    make_response
} from '/opt/nodejs/helper.mjs'

import { DynamoDBClient } from '@aws-sdk/client-dynamodb'
import {v4 as uuidv4} from 'uuid'
import {
    DynamoDBDocumentClient,
    PutCommand,
    GetCommand
} from '@aws-sdk/lib-dynamodb'

const user_table_name = process.env.USER_TABLE_NAME;
const region = process.env.REGION;
const client = new DynamoDBClient({region: region});
const doc_client = DynamoDBDocumentClient.from(client);

export const health_check = () => {
    return make_response(200);
}
export const create_user =async (body) => {
    try {
        if(!body) return make_response(500, {"message": "No request body was found"});  
        if (!body.name || !body.email) {
            return make_response(500, { "message": "Please provide valid name and email" });
        }

        if (!body.id) {
            body.id = uuidv4();
        }

        const command = new PutCommand({
            TableName : user_table_name,
            Item : body
        })

        const user = await doc_client.send(command);
        console.log("🟢 User created successfully: "+ user);
        return make_response(200, {
            "message": "Product Created",
            "Id" : body.id
        })
    } catch (error) {
        console.log(error?.message || error)
        throw new Error(error?.message || error);
    }
}
export const get_user = async (id) =>{
    try{
        if(!id) make_response(404, {"message": "user id was not provided"});
        const command = new GetCommand({
            TableName: user_table_name,
            Key: {user_id : id}
        })
        const user= await doc_client.send(command);
        console.log(user)
        if(!user) make_response(404, {"message":"No user found"});
        return make_response(200, {"message":"User found", 
            "user": user
        })
    }catch(error)
    {
        console.log("error in get user : " , error?.message || error)
        throw new Error(error?.message || error)
    }
}
export const delete_user= async (id) => {
    try {
        if(!id) make_response(404, {"message":"user id was not provided"});
        const command = new DeleteCommand({
            TableName: user_table_name,
            Key: {user_id: id}
        })
        const delete_response = await doc_client.send(command);
        console.log(delete_response);
    } catch (error) {
        console.log(error?.message || error)
        throw new Error(error?.message || error)
    }
}