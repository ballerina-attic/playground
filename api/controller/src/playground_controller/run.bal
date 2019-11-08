import ballerina/http;
import ballerina/system;
import ballerina/io;
import ballerina/log;

final string ASSOCIATED_CONNECTION = "ASSOCIATED_CONNECTION";
final string POST_COMPILE_CALLBACK = "POST_COMPILE_CALLBACK";

function invokeExecutor(http:WebSocketCaller frontEndCaller, RunData data) returns error? {
    string executorHost = system:getEnv("EXECUTOR_HOST");
    log:printDebug("executor-proxy:selectedHost: " + executorHost);
    service Callback = @http:WebSocketServiceConfig {} service {
        resource function onText(http:WebSocketClient conn, string text, boolean finalFrame) {
            log:printDebug("executor-proxy:OnText: " + text);
            var frontEndCaller = <http:WebSocketCaller> conn.getAttribute(ASSOCIATED_CONNECTION);
            error? pushText = frontEndCaller->pushText(text);
            if (pushText is error) {
                log:printError("Error while replying to front end.");
            }
        }
        resource function onError(http:WebSocketClient conn, error err) {
            log:printError("executor-proxy:OnError: " + err.reason());
            var frontEndCaller = <http:WebSocketCaller> conn.getAttribute(ASSOCIATED_CONNECTION);
            error? pushText = frontEndCaller->pushText({
                'type: "Error",
                data: "Error while executing. " + err.reason()
            });
            if (pushText is error) {
                io:println("Error while replying to front end.");
            }
        }
    };
    http:WebSocketClient executorClient = new(executorHost,
                            config = {callbackService: Callback});
    executorClient.setAttribute(ASSOCIATED_CONNECTION, frontEndCaller);
    json executeRequest = {
        'type: "Execute",
        'data: check json.constructFrom(data)
    };
    log:printDebug("executor-proxy:execute: " + executeRequest.toJsonString());
    check executorClient->pushText(executeRequest);
}

function hasCompilationEndedSuccessfully(string msg) returns [boolean,boolean]|error {
    PlaygroundResponse resp = check PlaygroundResponse.constructFrom(check msg.fromJsonString());       
    if (resp.'type is ControlResponse) {
        if (resp.data == "Finished Compiling with errors.") {
            return [true, false];
        }
        if (resp.data === "Finished Compiling.") {
            return [true, true];
        }
    }
    return [false, false];
}

function invokeCompiler(http:WebSocketCaller frontEndCaller, RunData data, CompilerCallback cb) returns error? {
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
            [boolean,boolean]|error compilationStatus = hasCompilationEndedSuccessfully(text);
            if (compilationStatus is error) {
                log:printError("Error while detecting compilation status. ", compilationStatus);
            } else if (compilationStatus == [true, true]) {
                CompilerCallback callback = <CompilerCallback> conn.getAttribute(POST_COMPILE_CALLBACK);
                callback(true);
            } else if (compilationStatus == [true, false]) {
                CompilerCallback callback = <CompilerCallback> conn.getAttribute(POST_COMPILE_CALLBACK);
                callback(false);
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
            CompilerCallback callback = <CompilerCallback> conn.getAttribute(POST_COMPILE_CALLBACK);
            callback(false);
        }
    };
    http:WebSocketClient compilerClient = new(compilerHost,
                            config = {callbackService: Callback});
    compilerClient.setAttribute(ASSOCIATED_CONNECTION, frontEndCaller);
    compilerClient.setAttribute(POST_COMPILE_CALLBACK, cb);
    json compileRequest = {
        'type: "Compile",
        'data: check json.constructFrom(data)
    };
    log:printDebug("compiler-proxy:compile: " + compileRequest.toJsonString());
    check compilerClient->pushText(compileRequest);
}

function run(http:WebSocketCaller caller, RunData data) returns error? {
    CompilerCallback compilerCallBack = function(boolean isSuccess) {
        log:printInfo("Call back hit with status " + isSuccess.toString());
        if (isSuccess) {
            error? executorResult = invokeExecutor(caller, data);
            if (executorResult is error) {
                log:printError("Error with executor. " + executorResult.reason());
            }
        }
    };

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
            error? compilerResult = invokeCompiler(caller, data, compilerCallBack);
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