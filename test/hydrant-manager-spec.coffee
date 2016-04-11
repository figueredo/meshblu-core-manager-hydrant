uuid           = require 'uuid'
redis          = require 'ioredis'
HydrantManager = require '..'

describe 'HydrantManager', ->
  beforeEach (done) ->
    @client = redis.createClient()
    @uuidAliasResolver = resolve: (uuid, callback) => callback(null, uuid)
    @client.on 'ready', done

  beforeEach 'hydrant setup', ->
    hydrantClient = redis.createClient()
    @sut = new HydrantManager {
      @uuidAliasResolver
      client: hydrantClient
    }

  describe 'connect', ->
    beforeEach (done) ->
      @nonce = Date.now()
      @sut.once 'message', (@message) => done()
      @sut.connect uuid: 'some-uuid', =>
        @client.publish 'some-uuid', @nonce, (error) =>
          return done error if error?

    it 'should receive a message', ->
      expect(@message).to.equal @nonce
