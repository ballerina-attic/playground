import ballerina/http;
import ballerina/io;

type RunRequest record {
    string sourceCode;
    string 'version = "1.0.1";
};

service runner on new http:Listener(9090) {
    @http:ResourceConfig {
        methods: ["POST"],
        body: "runReq",
        consumes: ["application/json"],
        produces: ["application/json"]
    }
    resource function run(http:Caller caller, http:Request request, RunRequest runReq) {
        string? cacheId = getCacheId(runReq.sourceCode);
        if (cacheId is string) {
            boolean hasCachedOutputResult = hasCachedOutput(cacheId);
            if (hasCachedOutputResult) {
                string? cachedOutput = getCachedOutput(cacheId);
                if (cachedOutput is string) {
                    error? result = caller->respond("From Cache: " + cachedOutput );
                    if (result is error) {
                        io:println("Error while responding: ", result);
                    }
                } else {
                    
                }
            } else {
                string newResp = "This is the output";
                setCachedOutput(cacheId, newResp);
                error? result = caller->respond("New Cache: " + newResp );
                if (result is error) {
                    io:println("Error while responding: ", result);
                }
            }
        } else {
            error? result = caller->respond("Cannot create cache");
            if (result is error) {
                io:println("Error while responding: ", result);
            }
            
        }
    }
}
