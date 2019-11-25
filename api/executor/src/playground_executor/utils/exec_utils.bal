import ballerina/io;
import ballerina/lang.'string;
import ballerina/system;
import ballerina/runtime;

function execJar(string cwd, string jar, ResponseHandler respHandler) returns error? {
    system:Process exec = check system:exec("java", {}, cwd , "-jar", jar);
    // time out execution in 30 seconds
    boolean timedOut = false;
    worker timer {
        runtime:sleep(30000);
        exec.destroy();
        timedOut = true;
    }
    NewLineHandler outPutHandler = function(string line) {
        respHandler(createDataResponse(line));
    };
    NewLineHandler errorHandler = function(string line) {
        respHandler(createErrorResponse(line));
    };
    error? outReadStatus = readFromByteChannel(exec.stdout(), outPutHandler);
    error? errReadStatus = readFromByteChannel(exec.stderr(), errorHandler);
    int exitCode = check exec.waitForExit();
    if (timedOut) {
        respHandler(createErrorResponse("Execution timed-out in 30 seconds."));
    } else if (outReadStatus is error) {
        respHandler(createErrorResponse("Error reading from standard out stream."));
    } else if (errReadStatus is error) {
        respHandler(createErrorResponse("Error reading from standard error stream."));
    }
    if (exitCode != 0) {
        respHandler(createErrorResponse("Program exitted with a non-zero exit code. " 
            + exitCode.toString()));
    }
}

type NewLineHandler function(string line);

function readFromByteChannel(io:ReadableByteChannel byteChannel, 
        NewLineHandler newLineHandler) returns error? {
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
