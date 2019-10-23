import ballerina/http;
import ballerina/io;

service playground on new http:Listener(9090) {
    resource function compile(http:Caller caller, http:Request request) {
        error? result = caller->respond("Compiling Ballerina...");
        if (result is error) {
            io:println("Error while responding: ", result);
        }
    }
}
