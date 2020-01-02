import ballerina/io;
import ballerina/lang.'string;
import ballerina/system;

function execBallerinaCmd(ResponseHandler respHandler, string? cwd = (), string... args) returns @tainted error? {
    system:Process exec = check system:exec("ballerina", {}, cwd , ...args);
    NewLineHandler outPutHandler = function(string line) {
        respHandler(createDataResponse(line));
    };
    NewLineHandler errorHandler = function(string line) {
        respHandler(createErrorResponse(line));
    };
    check readFromByteChannel(exec.stdout(), outPutHandler);
    check readFromByteChannel(exec.stderr(), errorHandler);
    int exitCode = check exec.waitForExit();
    if (exitCode == 0) {
        respHandler(createControlResponse("Finished Compiling."));
    } else {
        respHandler(createControlResponse("Finished Compiling with errors."));
    }
}

type NewLineHandler function(string line);

function readFromByteChannel(io:ReadableByteChannel byteChannel, 
        NewLineHandler newLineHandler) returns @tainted error? {
    string currentLine = "";
    while (true) {
        byte[]| error read = byteChannel.read(1);
        if (read is io:EofError) {
            // respond with rest
            newLineHandler(currentLine);
            break;
        } else if (read is error) {
            return <@untainted>read;
        } else {
            string fromBytes = check 'string:fromBytes(read);
            currentLine += <@untainted>fromBytes;
            if (fromBytes === "\n") {
                newLineHandler(currentLine);
                currentLine = "";
            }
        }
    }
}