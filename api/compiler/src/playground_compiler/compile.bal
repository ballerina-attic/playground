import ballerina/http;
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

function compile(http:WebSocketCaller caller, CompileData data) returns error? {
    string? cacheId = getCacheId(data.sourceCode);
    if (cacheId is string) {
        boolean hasCachedJarResult = hasCachedJar(cacheId);
        if (hasCachedJarResult) {
            string? cachedJar = getCachedJar(cacheId);
            if (cachedJar is string) {
                CompilerResponse response = createDataResponse("From Jar Cache" + cachedJar);
                check caller->pushText(check createStringResponse(response));
            } else {

            }
        } else {
            string sourceFile = check createSourceFile(cacheId, data.sourceCode);
            setCachedJar(cacheId, sourceFile);
            CompilerResponse response = createDataResponse("New Jar Cache: " + sourceFile);
            // compile and set jar
            check caller->pushText(check createStringResponse(response));
        }
    } else {
        CompilerResponse response = createErrorResponse("Cannot access cache");
        check caller->pushText(check createStringResponse(response));
    }
}

function createStringResponse(CompilerResponse reponse) returns json|error {
    json jsonResp = check json.constructFrom(reponse);
    return jsonResp.toJsonString();
}

function createDataResponse(string data) returns CompilerResponse {
    return <CompilerResponse> { "type": DataResponse, "data": data };
}

function createErrorResponse(string data) returns CompilerResponse {
    return <CompilerResponse> { "type": ErrorResponse, "data": data };
}