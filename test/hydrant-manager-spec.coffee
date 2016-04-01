uuid           = require 'uuid'
redis          = require 'fakeredis'
HydrantManager = require '..'

describe 'HydrantManager', ->
  beforeEach ->
    @redisKey = uuid.v1()
    @client = redis.createClient @redisKey
    @uuidAliasResolver = resolve: (uuid, callback) => callback(null, uuid)

    hydrantClient = redis.createClient @redisKey
    @sut = new HydrantManager {
      uuid: 'some-uuid'
      @uuidAliasResolver
      client: hydrantClient
    }

  describe 'connect', ->
    beforeEach (done) ->
      @nonce = Date.now()
      @sut.once 'message', (@message) => done()
      @sut.connect =>
        @client.publish 'some-uuid', @nonce, (error) =>
          return done error if error?

    it 'should receive a message', ->
      expect(@message).to.equal @nonce
