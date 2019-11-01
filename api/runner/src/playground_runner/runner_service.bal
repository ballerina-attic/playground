import ballerina/http;

@http:WebSocketServiceConfig {
    path: "/runner/run"
}
service runnerService on new http:Listener(9090) {
    resource function onText(http:WebSocketCaller caller, string data, boolean finalFrame) {
        RunnerRequest|error request = parseRequest(data);
        if (request is error) {
            checkpanic caller->pushText("Invalid Request. " + request.reason());
        } else {
            if (request.'type == RunRequest) {
                RequestData reqData = request.data;
                if (reqData is RunData) {
                    checkpanic run(caller, reqData);
                } else {
                    checkpanic caller->pushText("Invalid Request Data for Run Cmd. ");
                }
            }
        }
    }
}

function parseRequest(string data) returns RunnerRequest|error {
    return RunnerRequest.constructFrom(check data.fromJsonString());
}