import ballerina/file;
import ballerina/filepath;
import ballerina/io;
import ballerina/log;

const buildCacheDir = "/build-cache";

# Create a directory for the given source in build cache dir
# and create new file containing given source.
#
# + cacheId - cacheId Cache ID for the given source
# + sourceCode - sourceCode
# + return - Absolute path of the created file or an error
# 
function createSourceFile(string cacheId, string sourceCode) returns @tainted string|error {
    if (file:exists(buildCacheDir)) {
        log:printDebug("Build cache is mounted. " );
        string cachedBuildDir = check filepath:build(buildCacheDir, cacheId);
        string cachedAppPath = check filepath:build(buildCacheDir, cacheId, "app.bal");
        if (!file:exists(cachedAppPath)) {
            log:printDebug("Creating source file for compilation. " + cachedAppPath);
            io:WritableByteChannel appFile = check io:openWritableFile(cachedAppPath);
            _ = check appFile.write(sourceCode.toBytes(), 0);
            check appFile.close();
        } else {
            log:printDebug("Found existing source file for compilation. " + cachedAppPath);
        }
        return cachedAppPath;
    } else {
        log:printError("Build cache is not mounted. " );
        return file:FileNotFoundError( message = "Build Cache Directory " + buildCacheDir + " not found.");
    }
}

function compile(CompileData data, ResponseHandler respHandler) returns @tainted  error? {
    log:printDebug("Compiling request: " + data.toString());
    string cacheId = getCacheId(data.sourceCode, data.balVersion);
    string sourceFile = check createSourceFile(cacheId, data.sourceCode);
    string buildDir = check filepath:parent(sourceFile);
    log:printDebug("Using " + sourceFile + " for compilation.");
    check execBallerinaCmd(respHandler, <@untainted>buildDir, "build", "app.bal");
    check file:remove(<@untainted>sourceFile);
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
