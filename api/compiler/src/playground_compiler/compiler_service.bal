import ballerina/http;
import ballerina/io;

service compiler on new http:Listener(9090) {
    resource function 'version(http:Caller caller, http:Request request) {
        string versionInfo = checkpanic execBallerinaCmd("version");
        error? result = caller->respond(versionInfo);
        if (result is error) {
            io:println("Error while responding: ", result);
            
        }
    }
}
