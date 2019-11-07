import ballerina/file;
import ballerina/filepath;
import ballerina/io;

const buildCacheDir = "/build-cache";

# Create a directory for the given source in build cache dir
# and create new file containing given source.
#
# + cacheId - cacheId Cache ID for the given source
# + sourceCode - sourceCode
# + return - Absolute path of the created file or an error
# 
function createSourceFile(string cacheId, string sourceCode) returns string|error {
    if (file:exists(buildCacheDir)) {
        string cachedBuildDir = check filepath:build(buildCacheDir, cacheId);
        string cachedAppPath = check filepath:build(buildCacheDir, cacheId, "app.bal");
        if (!file:exists(cachedBuildDir)) {
            io:WritableByteChannel appFile = check io:openWritableFile(cachedAppPath);
            _ = check appFile.write(sourceCode.toBytes(), 0);
            check appFile.close();
        }
        return cachedAppPath;
    } else {
        return file:FileNotFoundError( message = "Build Cache Directory " + buildCacheDir + " not found.");
    }
}

function compile(CompileData data) returns CompilerResponse|error {
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
            string sourceFile = check createSourceFile(cacheId, data.sourceCode);
            string buildDir = check filepath:parent(sourceFile);
            string|error execStatus = execBallerinaCmd(buildDir, "build", "app.bal");
            if (execStatus is error) {
                 return createErrorResponse(execStatus.reason());
            } else {
                string jarPath = check filepath:build(buildDir, "app.jar");
                setCachedOutput(cacheId, execStatus);
                return createDataResponse(execStatus);
            }
        }
    } else {
        return createErrorResponse("Cannot access cache");
    }
}

function createStringResponse(CompilerResponse reponse) returns string|error {
    json jsonResp = check json.constructFrom(reponse);
    return jsonResp.toJsonString();
}

function createControlResponse(string data) returns CompilerResponse {
    return <CompilerResponse> { "type": ControlResponse, "data": data };
}


function createDataResponse(string data) returns CompilerResponse {
    return <CompilerResponse> { "type": DataResponse, "data": data };
}

function createErrorResponse(string data) returns CompilerResponse {
    return <CompilerResponse> { "type": ErrorResponse, "data": data };
}