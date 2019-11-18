import playground_commons as commons;
import ballerina/system;

const GITHUB_ACCESS_TOKEN = "GITHUB_ACCESS_TOKEN";
string token = system:getEnv(GITHUB_ACCESS_TOKEN);

function createGist(CreateGistRequest createReq) returns @untainted commons:Gist|error {
    string fileName = <@untainted> createReq.fileName;
    string content = <@untainted> createReq.content;
    string description = <@untainted> createReq.description;
    commons:GistClient gistClient = new({ token: token });
    return gistClient->createGist(fileName, content, description);
}

function getGistFile(string gistId, string fileName) returns @untainted commons:GistFile|error {
    commons:GistClient gistClient = new;
    commons:Gist gist = check gistClient->getGist(gistId);
    commons:GistFile gistFile;
    map<commons:GistFile> files = gist.files;
    if (files.hasKey(fileName)) {
      return files.get(fileName);
    } else {
      return error("Cannot find the file named " 
        + fileName + " in gist " + gistId);
    }
}