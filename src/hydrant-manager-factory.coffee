redis          = require 'ioredis'
RedisNS        = require '@octoblu/redis-ns'
HydrantManager = require '..'

class HydrantManagerFactory
  constructor: ({@uuidAliasResolver, @namespace, @redisUri}) ->

  build: =>
    client = new RedisNS @namespace, redis.createClient(@redisUri)
    new HydrantManager {client, @uuidAliasResolver}

module.exports = HydrantManagerFactory
