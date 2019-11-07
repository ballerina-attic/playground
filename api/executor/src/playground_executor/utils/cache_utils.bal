import ballerina/crypto;
import ballerina/cache;

cache:Cache inMemCache = new();

function getCacheId(string sourceCode, string balVersion) returns string? {
    string cacheSource = sourceCode + balVersion;
    return crypto:hashMd5(cacheSource.toBytes()).toBase16();
}

function hasCachedOutput(string cacheId) returns boolean {
   return inMemCache.hasKey(cacheId);
}

function getCachedOutput(string cacheId) returns string? {
    return <string?> inMemCache.get(cacheId);
}

function setCachedOutput(string cacheId, string output) {
   inMemCache.put(cacheId, output);
}