import ballerina/io;
import ballerina/lang.'string;
import ballerina/system;

public function execBallerinaCmd(string cmd, string[] args = []) returns string|error {
    system:Process exec = check system:exec("ballerina", {}, (), cmd);
    int waitForExit = check exec.waitForExit();
    return check readFromByteChannel(exec.stdout());
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
