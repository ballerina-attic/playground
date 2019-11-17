import ballerina/http;
import ballerina/log;

@http:WebSocketServiceConfig {
    path: "/controller"
}
service controllerService on new http:Listener(9090) {
    resource function onText(http:WebSocketCaller caller, string data, boolean finalFrame) {
        PlaygroundRequest|error request = parseRequest(data);
        if (request is error) {
            respondAndHandleErrors(caller, "Invalid Request. " + request.reason());
        } else {
            if (request.'type == RunRequest) {
                RequestData reqData = request.data;
                if (reqData is RunData) {
                    error? runStatus = run(caller, reqData);
                    if (runStatus is error) {
                        string msg = "Error while running: " + runStatus.reason();
                        json|error jsonResponse = createJSONResponse(createErrorResponse(msg));
                        if (jsonResponse is error) {
                            log:printError(msg + "\n" + jsonResponse.reason());
                        } else {
                            respondAndHandleErrors(caller, jsonResponse.toString());
                        }
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

function parseRequest(string data) returns PlaygroundRequest|error {
    return PlaygroundRequest.constructFrom(check data.fromJsonString());
}