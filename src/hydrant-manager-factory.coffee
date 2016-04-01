redis          = require 'ioredis'
RedisNS        = require '@octoblu/redis-ns'
HydrantManager = require '..'

class HydrantManagerFactory
  constructor: ({@uuidAliasResolver, @namespace, @redisUri}) ->

  build: (uuid) =>
    client = new RedisNS @namespace, redis.createClient(@redisUri)
    new HydrantManager {uuid, client, @uuidAliasResolver}

module.exports = HydrantManagerFactory
