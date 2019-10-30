import ballerina/http;

function run(http:WebSocketCaller caller, RunData data) returns error? {
    string? cacheId = getCacheId(data.sourceCode);
    if (cacheId is string) {
        boolean hasCachedOutputResult = hasCachedOutput(cacheId);
        if (hasCachedOutputResult) {
            string? cachedOutput = getCachedOutput(cacheId);
            if (cachedOutput is string) {
                RunnerResponse response = createDataResponse("From Cache: " + cachedOutput);
                check caller->pushText(check createStringResponse(response));
            } else {

            }
        } else {
            string newResp = "This is the output";
            setCachedOutput(cacheId, newResp);
            RunnerResponse response = createDataResponse("New Cache: " + newResp);
            check caller->pushText(check createStringResponse(response));
        }
    } else {
        RunnerResponse response = createErrorResponse("Cannot access cache");
        check caller->pushText(check createStringResponse(response));
    }
}

function createStringResponse(RunnerResponse reponse) returns json|error {
    json jsonResp = check json.constructFrom(reponse);
    return jsonResp.toJsonString();
}

function createDataResponse(string data) returns RunnerResponse {
    return <RunnerResponse> { "type": DataResponse, "data": data };
}

function createErrorResponse(string data) returns RunnerResponse {
    return <RunnerResponse> { "type": ErrorResponse, "data": data };
}