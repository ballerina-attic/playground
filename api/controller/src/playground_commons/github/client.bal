import ballerina/http;

const API_HOST = "https://api.github.com";
const GISTS_RESOURCE = "gists";

public type GistClient client object {

    string accessToken;
    http:Client restClient;

    public function __init(GithubClientConfig config) {
        self.accessToken = config.token;
        self.restClient = new (API_HOST, config.httpClientConfig);
    }

    public remote function createGist(string fileName, 
            string content, string description) returns  @tainted Gist|error {
        json reqBody = {
            "description": description,
            "public": true,
            "files": {
                fileName: {
                    "content": content
                }
            }
        };
        http:Request req = self.createRequest(reqBody);
        var response = check self.restClient->post("/" + GISTS_RESOURCE, req);
        return parseResponse(response);
    }

    public remote function getGist(string gistId) returns @tainted Gist|error {
        http:Request req = self.createRequest();
        var response = check self.restClient->get("/" +GISTS_RESOURCE + "/" + gistId);
        return parseResponse(response);
    }

    private function createRequest(json payload = ()) returns http:Request {
        http:Request req = new();
        req.setHeader("Authorization", "token " + self.accessToken);
        req.setHeader("Accept", "application/vnd.github.v3+json");
        if (!(payload is ())) {
            req.setJsonPayload(payload);
        }
        return req;
    }
};

public type GithubClientConfig record {
    string token;
    http:ClientConfiguration httpClientConfig;
};

