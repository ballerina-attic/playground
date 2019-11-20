import ballerina/file;
import ballerina/filepath;
import ballerina/log;

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
    log:printDebug("Executing request: " + data.toString());
    string cacheId = getCacheId(data.sourceCode, data.balVersion);
    string appJar = check getAppJar(cacheId);
    log:printDebug("Executing jar: " + appJar);
    string cwd = check filepath:parent(appJar);
    string|error execStatus = execJar(cwd, appJar);
    if (execStatus is error) {
        log:printError("Error while executing jar: " + execStatus.reason());
        return createErrorResponse(execStatus.reason());
    } else {
        log:printDebug("Executed jar: " + execStatus);
        return createDataResponse(execStatus);
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