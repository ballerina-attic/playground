import ballerinax/java;

public function redisGet(string key) returns string = @java:Method {
    name: "get",
    class:"org/ballerinalang/playground/cache/RedisCache"
} external;

public function redisContains(string key) returns boolean = @java:Method {
    name: "contains",
    class:"org/ballerinalang/playground/cache/RedisCache"
} external;

public function redisSet(string key, string value) = @java:Method {
    name: "set",
    class:"org/ballerinalang/playground/cache/RedisCache"
} external;