import ballerina/http;

function parseResponse(http:Response response) returns @tainted Gist|error {
   if (response.statusCode == http:STATUS_CREATED 
        || response.statusCode == http:STATUS_OK ) {
       return Gist.constructFrom(check response.getJsonPayload());
   } else if (response.statusCode == http:STATUS_NOT_FOUND) {
       return error("404 Not Found. Check gist id.");
   } else {
       return error("Unhandled response code: " + response.statusCode.toString() + "\n"
        + response.getTextPayload().toString());
   }
}