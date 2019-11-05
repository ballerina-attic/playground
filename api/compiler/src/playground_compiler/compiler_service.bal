import ballerina/http;

@http:WebSocketServiceConfig {
    path: "/compiler"
}
service compilerService on new http:Listener(9090) {
    resource function onText(http:WebSocketCaller caller, string data, boolean finalFrame) {
        CompilerRequest|error request = parseRequest(data);
        if (request is error) {
            checkpanic caller->pushText("Invalid Request. " + request.reason());
        } else {
            if (request.'type == CompileRequest) {
                RequestData reqData = request.data;
                if (reqData is CompileData) {
                    checkpanic compile(caller, reqData);
                } else {
                    checkpanic caller->pushText("Invalid Request Data for Compile Cmd. ");
                }
            }
        }
    }
}

function parseRequest(string data) returns CompilerRequest|error {
    return CompilerRequest.constructFrom(check data.fromJsonString());
}
