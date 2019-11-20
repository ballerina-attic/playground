import ballerina/crypto;

function getCacheId(string sourceCode, string balVersion) returns string {
    string cacheSource = sourceCode + balVersion;
    return crypto:hashMd5(cacheSource.toBytes()).toBase16();
}