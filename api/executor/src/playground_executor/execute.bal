import ballerina/file;
import ballerina/filepath;
const buildCacheDir = "/build-cache";

function getAppJar(string cacheId) returns string|error {
    if (file:exists(buildCacheDir)) {
        string cachedBuildDir = check filepath:build(buildCacheDir, cacheId);
        string cachedAppPath = check filepath:build(buildCacheDir, cacheId, "app.jar");
        if (file:exists(cachedBuildDir)) {
            return cachedAppPath;
        } 
        return file:FileNotFoundError(message = "Cannot find " + cachedAppPath);
    } else {
        return file:FileNotFoundError( message = "Build Cache Directory " + buildCacheDir + " not found.");
    }
}

function execute(ExecuteData data) returns ExecutorResponse|error {
    string? cacheId = getCacheId(data.sourceCode, data.balVersion);
    if (cacheId is string) {
        boolean hasCachedOutputResult = hasCachedOutput(cacheId);
        if (hasCachedOutputResult) {
            string? cachedOutput = getCachedOutput(cacheId);
            if (cachedOutput is string) {
                return createDataResponse(cachedOutput);
            } else {
                return createErrorResponse("Invalid cached output returned from cache.");
            }
        } else {
            string appJar = check getAppJar(cacheId);
            string cwd = check filepath:parent(appJar);
            string|error execStatus = execJar(cwd, appJar);
            if (execStatus is error) {
                 return createErrorResponse(execStatus.reason());
            } else {
                setCachedOutput(cacheId, execStatus);
                return createDataResponse(execStatus);
            }
        }
    } else {
        return createErrorResponse("Cannot access cache");
    }
}

function createStringResponse(ExecutorResponse reponse) returns string|error {
    json jsonResp = check json.constructFrom(reponse);
    return jsonResp.toJsonString();
}

function createControlResponse(string data) returns ExecutorResponse {
    return <ExecutorResponse> { "type": ControlResponse, "data": data };
}


function createDataResponse(string data) returns ExecutorResponse {
    return <ExecutorResponse> { "type": DataResponse, "data": data };
}

function createErrorResponse(string data) returns ExecutorResponse {
    return <ExecutorResponse> { "type": ErrorResponse, "data": data };
}