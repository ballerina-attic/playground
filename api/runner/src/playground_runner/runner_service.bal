import ballerina/http;
import ballerina/log;

@http:WebSocketServiceConfig {
    path: "/runner"
}
service runnerService on new http:Listener(9090) {
    resource function onText(http:WebSocketCaller caller, string data, boolean finalFrame) {
        RunnerRequest|error request = parseRequest(data);
        if (request is error) {
            respondAndHandleErrors(caller, "Invalid Request. " + request.reason());
        } else {
            if (request.'type == RunRequest) {
                RequestData reqData = request.data;
                if (reqData is RunData) {
                    error? runStatus = run(caller, reqData);
                    if (runStatus is error) {
                        log:printError("Error while running: " + runStatus.reason());
                    }
                } else {
                    respondAndHandleErrors(caller, "Invalid Request Data for Run Cmd. ");
                }
            }
        }
    }
}

function respondAndHandleErrors(http:WebSocketCaller caller, string response) {
    error? status = caller->pushText(response);
    if (status is error) {
        log:printError("Error while responding: " + response);
    }
}

function parseRequest(string data) returns RunnerRequest|error {
    return RunnerRequest.constructFrom(check data.fromJsonString());
}