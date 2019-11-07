import ballerina/http;
import ballerina/system;
import ballerina/io;
import ballerina/log;

final string ASSOCIATED_CONNECTION = "ASSOCIATED_CONNECTION";

function invokeCompiler(http:WebSocketCaller frontEndCaller, string cacheId, RunData data) returns error? {
    string compilerHost = system:getEnv("COMPILER_HOST");
    log:printDebug("compiler-proxy:selectedHost: " + compilerHost);
    service Callback = @http:WebSocketServiceConfig {} service {
        resource function onText(http:WebSocketClient conn, string text, boolean finalFrame) {
            log:printDebug("compiler-proxy:OnText: " + text);
            var frontEndCaller = <http:WebSocketCaller> conn.getAttribute(ASSOCIATED_CONNECTION);
            error? pushText = frontEndCaller->pushText(text);
            if (pushText is error) {
                log:printError("Error while replying to front end.");
            }
        }
        resource function onError(http:WebSocketClient conn, error err) {
            log:printError("compiler-proxy:OnError: " + err.reason());
            var frontEndCaller = <http:WebSocketCaller> conn.getAttribute(ASSOCIATED_CONNECTION);
            error? pushText = frontEndCaller->pushText({
                'type: "Error",
                data: "Error while compiling. " + err.reason()
            });
            if (pushText is error) {
                io:println("Error while replying to front end.");
            }
        }
    };
    http:WebSocketClient compilerClient = new(compilerHost,
                            config = {callbackService: Callback});
    compilerClient.setAttribute(ASSOCIATED_CONNECTION, frontEndCaller);
    json compileRequest = {
        'type: "Compile",
        'data: check json.constructFrom(data)
    };
    log:printDebug("compiler-proxy:compile: " + compileRequest.toJsonString());
    check compilerClient->pushText(compileRequest);
}

function run(http:WebSocketCaller caller, RunData data) returns error? {
    log:printDebug("controller:onRun: " + data.toString());
    string? cacheId = getCacheId(data.sourceCode, data.balVersion);
    if (cacheId is string) {
        boolean hasCachedOutputResult = hasCachedOutput(cacheId);
        string? cachedOutput = getCachedOutput(cacheId);
        if (hasCachedOutputResult && cachedOutput is string) {
            log:printDebug("controller:hasCachedOutput: " + data.toString());
            PlaygroundResponse response = createDataResponse("From Cache: " + cachedOutput);
            check caller->pushText(check createStringResponse(response));
        } else {
            log:printDebug("controller:noCachedOutput: " + data.toString());
            error? compilerResult = invokeCompiler(caller, cacheId, data);
            if (compilerResult is error) {
                log:printError("Error with compiler. " + compilerResult.reason());
            }
        }
    } else {
        log:printError("Cannot get cache ID");
        PlaygroundResponse response = createErrorResponse("Cannot get cache ID");
        check caller->pushText(check createStringResponse(response));
    }
}

function createStringResponse(PlaygroundResponse reponse) returns json|error {
    json jsonResp = check json.constructFrom(reponse);
    return jsonResp.toJsonString();
}

function createDataResponse(string data) returns PlaygroundResponse {
    return <PlaygroundResponse> { "type": DataResponse, "data": data };
}

function createErrorResponse(string data) returns PlaygroundResponse {
    return <PlaygroundResponse> { "type": ErrorResponse, "data": data };
}