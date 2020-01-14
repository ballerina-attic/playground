import ballerina/io;
import ballerina/lang.'string;
import ballerina/system;

function execBallerinaCmd(ResponseHandler respHandler, string? cwd = (), string... args) returns @tainted error? {
    system:Process exec = check system:exec("ballerina", {}, cwd , ...args);
    boolean compilationSuccess = true;
    NewLineHandler outPutHandler = function(string line) {
        respHandler(createDataResponse(line));
    };
    NewLineHandler errorHandler = function(string line) {
        respHandler(createErrorResponse(line));
        compilationSuccess = false;
    };
    check readFromByteChannel(exec.stdout(), outPutHandler);
    check readFromByteChannel(exec.stderr(), errorHandler);
    int exitCode = check exec.waitForExit();
    if (exitCode == 0 && compilationSuccess) {
        respHandler(createControlResponse("Finished Compiling."));
    } else {
        respHandler(createControlResponse("Finished Compiling with errors."));
    }
}

type NewLineHandler function(string line);

function readFromByteChannel(io:ReadableByteChannel byteChannel,
        NewLineHandler newLineHandler) returns error? {
    byte[] currentBytes = [];
    while (true) {
        byte[]|error read = byteChannel.read(1);
        if (read is io:EofError) {
            if (currentBytes.length() > 0) {
                string fromBytes = check 'string:fromBytes(currentBytes);
                string currentLine = <@untainted>fromBytes;
                // respond with rest
                newLineHandler(currentLine);
            }
            break;
        } else if (read is error) {
            return <@untainted>read;
        } else {
            if (read.length() > 0) {
                byte readByte = read[0];
                currentBytes.push(readByte);
                if (readByte === 0x0a) {
                    string fromBytes = check 'string:fromBytes(currentBytes);
                    string currentLine = <@untainted>fromBytes;
                    newLineHandler(currentLine);
                    currentBytes = [];
                }
            }
        }
    }
}