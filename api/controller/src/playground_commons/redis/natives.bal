import ballerinax/java;
import ballerinax/java.arrays;

public function redisGet(handle key) returns handle = @java:Method {
    name: "get",
    class:"org/ballerinalang/playground/cache/RedisCache"
} external;

public function redisGetList(string key) returns string[] {
    handle javaArray = redisGetListinternal(java:fromString(key));
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

function redisGetListinternal(handle key) returns handle = @java:Method {
    name: "getList",
    class:"org/ballerinalang/playground/cache/RedisCache"
} external;

public function redisContains(handle key) returns boolean = @java:Method {
    name: "contains",
    class:"org/ballerinalang/playground/cache/RedisCache"
} external;

public function redisSet(handle key, handle value) = @java:Method {
    name: "set",
    class:"org/ballerinalang/playground/cache/RedisCache"
} external;

public function redisRemove(handle key) = @java:Method {
    name: "remove",
    class:"org/ballerinalang/playground/cache/RedisCache"
} external;

public function redisPushToList(handle key, handle value) = @java:Method {
    name: "pushToList",
    class:"org/ballerinalang/playground/cache/RedisCache"
} external;

public function redisSetArray(handle key, handle value) = @java:Method {
    name: "set",
    class:"org/ballerinalang/playground/cache/RedisCache"
} external;