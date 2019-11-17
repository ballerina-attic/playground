package org.ballerinalang.playground.cache;

import redis.clients.jedis.Jedis;

import java.util.List;

/**
 * Cache Adaptor for Redis
 */
public class RedisCache {

    private static RedisClient redisClient;

    static {
        redisClient = RedisClient.getInstance();
    }

    public static String get(String key) throws Exception {
        return redisClient.getReadClient().get(key);
    }

    public static String[] getList(String key) {
        return redisClient.getReadClient()
                .lrange(key, 0, - 1).toArray(new String[0]);
    }

    public static boolean contains(String key) throws Exception  {
        return redisClient.getReadClient().exists(key);
    }

    public static void set(String key, String value) throws Exception {
        redisClient.getWriteClient().set(key, value);
    }

    public static void pushToList(String key, String value) throws Exception{
        redisClient.getWriteClient().lpush(key, value);
    }
}