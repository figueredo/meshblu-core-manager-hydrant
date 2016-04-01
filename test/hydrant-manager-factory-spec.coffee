uuid                  = require 'uuid'
redis                 = require 'fakeredis'
HydrantManager        = require '..'
HydrantManagerFactory = require '../factory'

describe 'HydrantManagerFactory', ->
  beforeEach ->
    @redisKey = uuid.v1()
    @client = redis.createClient @redisKey
    @uuidAliasResolver = resolve: (uuid, callback) => callback(null, uuid)

    hydrantClient = redis.createClient @redisKey
    @sut = new HydrantManagerFactory {
      @uuidAliasResolver
      client: hydrantClient
    }

  describe 'build', ->
    beforeEach ->
      @hydrantManager = @sut.build()

    it 'should create a HydrantManager', ->
      expect(@hydrantManager).to.be.an.instanceOf HydrantManager
