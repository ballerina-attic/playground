import ballerina/http;
import playground_commons as commons;
import ballerina/log;

@http:ServiceConfig {
    basePath: "/gists"
}
service gistsService on new http:Listener(9090) {
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/",
        body: "createReq",
        consumes: ["application/json"]
    }
    resource function create(http:Caller caller, http:Request request,
        CreateGistRequest createReq) {
        commons:Gist|error gist = createGist(createReq);
        if (gist is error) {
            respondAndHandleErrors(caller, createErrorResponse(gist));
        } else {
            respondAndHandleErrors(caller, gist);
        }
    }
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/{gistId}/{fileName}"
    }
    resource function get(http:Caller caller, http:Request request,
        string gistId, string fileName) {
        commons:GistFile|error gistFile = getGistFile(gistId, fileName);
        if (gistFile is error) {
            respondAndHandleErrors(caller, createErrorResponse(gistFile));
        } else {
            respondAndHandleErrors(caller, gistFile);
        }
    }
}

function createErrorResponse(error err) returns http:Response {
    http:Response errorResp = new;
    errorResp.statusCode = 500;
    errorResp.setTextPayload(err.reason() + "\n" + err.detail().toString());
    return errorResp;
}

function respondAndHandleErrors(http:Caller caller, 
            http:Response|commons:Gist|commons:GistFile|json|string response) {
    http:Response|json|string resp;
    if (response is commons:Gist || response is commons:GistFile) {
        json|error createdJson = json.constructFrom(response);
        if (createdJson is error) {
            string err = "Error while creating json: " + createdJson.reason();
            log:printError(err);
            resp = createErrorResponse(error(err));
        } else {
            resp = createdJson;
        }
    } else {
        resp = response;
    }
    error? status = caller->respond(resp);
    if (status is error) {
        log:printError("Error while responding: " + status.reason());
    }
}