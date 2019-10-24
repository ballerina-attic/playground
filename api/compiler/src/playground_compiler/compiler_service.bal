import ballerina/http;
import ballerina/io;
import ballerina/system;
import ballerina/lang.'string;

function readFromByteChannel(io:ReadableByteChannel byteChannel) returns string|error? {
    string content = "";
    while (true) {
        byte[]|error read = byteChannel.read(1000);
        if (read is io:EofError) {
            break;
        } else if (read is error) {
            return <@untainted> read;
        } else {
            string fromBytes = check 'string:fromBytes(read);
            content += <@untainted> fromBytes;
        }
    }
    return content;
}

@http:ServiceConfig {
    basePath: "/"
}
service compiler on new http:Listener(9090) {
    @http:ResourceConfig {
        path: "/versions"
    }
    resource function versions(http:Caller caller, http:Request request) {
        system:Process|error exec = system:exec("ballerina", {}, (), "version");
        string response = "";
        if (exec is error) {
          response = "Error occurred - " + exec.reason();
        } else {
            int|error waitForExit = exec.waitForExit();
            if (waitForExit is error) {
                response = "Error occurred - " + waitForExit.reason();
            } else {
                var read = readFromByteChannel(exec.stdout());
                if (read is error) {
                    response = "Error occurred - " + read.reason();
                } else if (read is string) {
                    response = read;
                } else {
                    response = "Unknown Error occurred ";
                }
            }
        }
        error? result = caller->respond(response);
        if (result is error) {
            io:println("Error while responding: ", result);
            
        }
    }
}
