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

    public static String get(String key) {
        try (Jedis client = redisClient.getReadClient()) {
            return client.get(key);
        }
    }

    public static String[] getList(String key) {
        try (Jedis client = redisClient.getReadClient()) {
            Long listLength = client.llen(key);
            return client.lrange(key, 0, listLength - 1).toArray(new String[0]);
        }
    }

    public static boolean contains(String key) {
        try (Jedis client = redisClient.getReadClient()) {
            return client.exists(key);
        }
    }

    public static void set(String key, String value) {
        try (Jedis client = redisClient.getWriteClient()) {
            client.set(key, value);
        }
    }

    public static void pushToList(String key, String value) {
        try (Jedis client = redisClient.getWriteClient()) {
            client.lpush(key, value);
        }
    }
}