import ballerina/http;

function parseResponse(http:Response response) returns @tainted Gist|error {
   if (response.statusCode == http:STATUS_CREATED 
        || response.statusCode == http:STATUS_OK ) {
       return Gist.constructFrom(check response.getJsonPayload());
   } else {
       return error("Invalid Response. " + response.statusCode.toString()
        + response.getTextPayload().toString());
   }
}