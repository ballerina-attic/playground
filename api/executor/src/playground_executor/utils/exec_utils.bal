import ballerina/io;
import ballerina/lang.'string;
import ballerina/system;
import ballerina/runtime;

public function execJar(string cwd, string jar) returns string|error {
    system:Process exec = check system:exec("java", {}, cwd , "-jar", jar);
    // time out execution in 30 seconds
    boolean timedOut = false;
    worker timer {
        runtime:sleep(30000);
        exec.destroy();
        timedOut = true;
    }
    int exitCode = check exec.waitForExit();
    if (timedOut) {
        return error("Execution timed-out in 30 seconds.");
    }
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
