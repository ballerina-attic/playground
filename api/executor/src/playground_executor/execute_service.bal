import ballerina/http;
import ballerina/log;

@http:WebSocketServiceConfig {
    path: "/executor"
}
service executorService on new http:Listener(9090) {
    resource function onText(http:WebSocketCaller caller, string data, boolean finalFrame) {
        ExecutorRequest|error request = parseRequest(data);
        if (request is error) {
            respond(caller, createErrorResponse("Unable to parse request. " + request.reason()));
        } else {
            if (request.'type == ExecuteRequest) {
                RequestData reqData = request.data;
                if (reqData is ExecuteData) {
                    respond(caller, createControlResponse("Executing Program."));
                    ExecutorResponse|error cmpResp = execute(reqData);
                    if (cmpResp is error) {
                        respond(caller, createErrorResponse("Error while executing. " + cmpResp.reason()));
                    } else {
                        respond(caller, cmpResp);
                    }
                    respond(caller, createControlResponse("Finished Executing."));
                } else {
                   respond(caller, createErrorResponse("Invalid request data. Expected: " + ExecuteData.toString())); 
                }
            } else {
                respond(caller, createErrorResponse("Invalid request payload. Expected: " + ExecutorRequest.toString()));
            }
        }
    }
}

function respondString(http:WebSocketCaller caller, string response) {
    error? status = caller->pushText(response);
    if (status is error) {
        log:printError("Error while responding to caller: " + caller.toString());
    }
}

function respond(http:WebSocketCaller caller, ExecutorResponse response) {
    string|error stringResponse = createStringResponse(response);
    if (stringResponse is error) {
        respond(caller, createErrorResponse("Unable to create a JSON string from response: "  
                    + response.toString()));
    } else {
        respondString(caller, stringResponse);
    }
}

function parseRequest(string data) returns ExecutorRequest|error {
    return ExecutorRequest.constructFrom(check data.fromJsonString());
}
