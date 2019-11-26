import ballerina/http;
import ballerina/log;

@http:WebSocketServiceConfig {
    path: "/compiler"
}
service compilerService on new http:Listener(9090) {
    resource function onText(http:WebSocketCaller caller, string data, boolean finalFrame) {
        CompilerRequest|error request = parseRequest(data);
        if (request is error) {
            respond(caller, createErrorResponse("Unable to parse request. " + request.reason()));
        } else {
            if (request.'type == CompileRequest) {
                RequestData reqData = request.data;
                if (reqData is CompileData) {
                    respond(caller, createControlResponse("Compiling Program."));
                    ResponseHandler respHandler = function(CompilerResponse resp) {
                        respond(caller, resp);
                    };
                    error? cmpResp = compile(reqData, respHandler);
                    if (cmpResp is error) {
                        string msg = "Error while compiling. ." + cmpResp.reason();
                        log:printError(msg);
                        respond(caller, createErrorResponse(msg));
                    }
                } else {
                   respond(caller, createErrorResponse("Invalid request data. Expected: " + CompileData.toString())); 
                }
            } else {
                respond(caller, createErrorResponse("Invalid request payload. Expected: " + CompileRequest.toString()));
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

function respond(http:WebSocketCaller caller, CompilerResponse response) {
    string|error stringResponse = createStringResponse(response);
    if (stringResponse is error) {
        respond(caller, createErrorResponse("Unable to create a JSON string from response: "  
                    + response.toString()));
    } else {
        respondString(caller, stringResponse);
    }
}

function parseRequest(string data) returns CompilerRequest|error {
    return CompilerRequest.constructFrom(check data.fromJsonString());
}
