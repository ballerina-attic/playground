import ballerina/io;
import ballerina/lang.'string;
import ballerina/system;

public function execBallerinaCmd(string? cwd = (), string... args) returns string|error {
    system:Process exec = check system:exec("ballerina", {}, cwd , ...args);
    int exitCode = check exec.waitForExit();
    if (exitCode == 0) {
        return check readFromByteChannel(exec.stdout());
    } else {
        return error(check readFromByteChannel(exec.stderr()));
    }
}

function readFromByteChannel(io:ReadableByteChannel byteChannel) returns string|error {
    string content = "";
    while (true) {
        byte[] | error read = byteChannel.read(1000);
        if (read is io:EofError) {
            break;
        } else if (read is error) {
            return <@untainted>read;
        } else {
            string fromBytes = check 'string:fromBytes(read);
            content += <@untainted>fromBytes;
        }
    }
    return content;
}
