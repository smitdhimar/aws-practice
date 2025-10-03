import {
    make_response
} from '/opt/nodejs/helper.mjs'

import { DynamoDBClient } from '@aws-sdk/client-dynamodb'
import { v4 as uuidv4 } from 'uuid'
import {
    DynamoDBDocumentClient,
    PutCommand,
    GetCommand,
    DeleteCommand,
    UpdateCommand
} from '@aws-sdk/lib-dynamodb'

const user_table_name = process.env.USER_TABLE_NAME;
const region = process.env.REGION;
const client = new DynamoDBClient({ region: region });
const doc_client = DynamoDBDocumentClient.from(client);

export const health_check = () => {
    return make_response(200);
}
export const create_user = async (body) => {
    try {
        if (!body) return make_response(500, { "message": "No request body was found" });
        if (!body.name || !body.email) {
            return make_response(500, { "message": "Please provide valid name and email" });
        }

        if (!body.id) {
            body.id = uuidv4();
        }

        const command = new PutCommand({
            TableName: user_table_name,
            Item: body
        })

        const user = await doc_client.send(command);
        console.log("🟢 User created successfully: " + user);
        return make_response(200, {
            "message": "Product Created",
            "Id": body.id
        })
    } catch (error) {
        console.log(error?.message || error)
        throw new Error(error?.message || error);
    }
}
export const get_user = async (id) => {
    try {
        if (!id) return make_response(404, { "message": "user id was not provided" });
        const command = new GetCommand({
            TableName: user_table_name,
            Key: { id }
        })
        const user = await doc_client.send(command);
        console.log(user)
        if (!user?.Item) return make_response(404, { "message": "No user found" });
        return make_response(200, {
            "message": "User found",
            "user": user.Item
        })
    } catch (error) {
        console.log("error in get user : ", error?.message || error)
        throw new Error(error?.message || error)
    }
}
export const delete_user = async (id) => {
    try {
        if (!id) return make_response(404, { "message": "user id was not provided" });
        const command = new DeleteCommand({
            TableName: user_table_name,
            Key: { id },
            ReturnValues: "ALL_OLD"
        })
        const delete_response = await doc_client.send(command);
        console.log(delete_response);
        const deletedItem = delete_response?.Attributes || delete_response?.Item || null;
        if (!deletedItem) {
            return make_response(404, { "message": "No user found to delete" });
        }
        return make_response(200, { "message": "User deleted", "id": id });
    } catch (error) {
        console.log(error?.message || error)
        throw new Error(error?.message || error)
    }
}
export const update_user = async (id, body) => {
    try {
        const update_expession = Object.keys(body)?.map((key)=> `#${key} = :${key}`)?.join(", ")
        const expression_attribute_names = Object.keys(body)?.reduce((acc,key)=> {
            acc[`#${key}`]= key;
            return acc;
        }, {})
        const expression_attribute_values = Object.keys(body)?.reduce((acc, key)=>{
            acc[`:${key}`] = body[key];
            return acc;
        }, {})

        const command = new UpdateCommand({
            TableName: user_table_name,
            Key: {id},
            UpdateExpression: `SET ${update_expession}`,
            ExpressionAttributeNames: expression_attribute_names,
            ExpressionAttributeValues: expression_attribute_values,
            ReturnValues: "ALL_NEW"
        })

        const update_user_result= await doc_client.send(command)
        console.log(update_user_result)
        if(!update_user_result?.Attributes) return make_response(500, {"message":"Error in updating the user"});
        return make_response(200, {
            "message": "Updated successfully",
            "body": update_user_result?.Attributes
        })
    } catch (error) {
        console.log(error?.message || error)
        throw new Error(error?.message || error)
    }
}