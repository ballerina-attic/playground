import ballerinax/java;
import ballerinax/java.arrays;

public function redisGet(string key) returns string = @java:Method {
    name: "get",
    class:"org/ballerinalang/playground/cache/RedisCache"
} external;

public function redisGetList(string key) returns string[] {
    handle javaArray = redisGetListinternal(key);
    int listLength = arrays:getLength(javaArray);
    int index = 0;
    string[] balArray = [];
    while (index < listLength - 1) {
        balArray[index] = <string> java:toString(arrays:get(javaArray, index));
        index += 1;
    }
    // make responses FIFO
    return balArray.reverse();
}

function redisGetListinternal(string key) returns handle = @java:Method {
    name: "getList",
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

public function redisPushToList(string key, string value) = @java:Method {
    name: "pushToList",
    class:"org/ballerinalang/playground/cache/RedisCache"
} external;

public function redisSetArray(string key, string value) = @java:Method {
    name: "set",
    class:"org/ballerinalang/playground/cache/RedisCache"
} external;