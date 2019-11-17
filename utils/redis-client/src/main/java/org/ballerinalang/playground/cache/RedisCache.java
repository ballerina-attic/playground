package org.ballerinalang.playground.cache;

import redis.clients.jedis.Jedis;

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
}