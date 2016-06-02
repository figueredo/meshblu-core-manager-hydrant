uuid                = require 'uuid'
Redis               = require 'ioredis'
MultiHydrantManager = require '../src/multi-hydrant-manager'

describe 'MultiHydrantManager', ->
  beforeEach (done) ->
    @client = new Redis dropBufferSupport: true
    @uuidAliasResolver = resolve: (uuid, callback) => callback(null, uuid)
    @client.on 'ready', done

  beforeEach 'hydrant setup', ->
    hydrantClient = new Redis dropBufferSupport: true
    @sut = new MultiHydrantManager {
      @uuidAliasResolver
      client: hydrantClient
    }

  describe 'connect', ->
    beforeEach (done) ->
      @nonce = Date.now()
      @sut.once 'message', (@channel, @message) => done()
      @sut.connect (error) =>
        return done error if error?
        @sut.subscribe uuid: 'some-uuid', (error) =>
          return done error if error?
          @client.publish 'some-uuid', @nonce, (error) =>
            return done error if error?

    it 'should receive a channel and message', ->
      expect(@message).to.equal @nonce
      expect(@channel).to.equal 'some-uuid'
