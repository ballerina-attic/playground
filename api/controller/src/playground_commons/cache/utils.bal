import ballerina/crypto;

public function getCacheId(string sourceCode, string suffix = "") returns string {
    string cacheSource = sourceCode + suffix;
    return crypto:hashMd5(cacheSource.toBytes()).toBase16();
}