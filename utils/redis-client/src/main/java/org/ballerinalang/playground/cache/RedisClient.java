package org.ballerinalang.playground.cache;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

/**
 * Redis Client
 */
public class RedisClient {

    private static JedisPool masterPool;
    private static JedisPool slavePool;

    private static int port = 6379;

    private static RedisClient instance;

    private RedisClient() {
        String writeHost = System.getenv("REDIS_WRITE_HOST");
        String readHost = System.getenv("REDIS_READ_HOST");
        if (writeHost == null|| readHost == null) {
            throw new IllegalArgumentException("Missing required environment variables for redis client." );
        }
        masterPool = new JedisPool(new JedisPoolConfig(),
                writeHost,
                port);
        slavePool = new JedisPool(new JedisPoolConfig(),
                readHost,
                port);
    }

    public static RedisClient getInstance () {
        if (instance == null) {
            instance = new RedisClient();
        }
        return instance;
    }

    public Jedis getWriteClient() {
        return masterPool.getResource();
    }

    public Jedis getReadClient() {
        return slavePool.getResource();
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        masterPool.close();
        slavePool.close();
    }
}
