import ballerina/crypto;
import ballerina/cache;

cache:Cache inMemCache = new();

function getCacheId(string sourceCode) returns string? {
    return crypto:hashMd5(sourceCode.toBytes()).toBase64();
}

function hasCachedOutput(string cacheId) returns boolean {
   return inMemCache.hasKey(cacheId);
}

function getCachedOutput(string cacheId) returns string? {
    return <string> inMemCache.get(cacheId);
}

function setCachedOutput(string cacheId, string output) {
   inMemCache.put(cacheId, output);
}