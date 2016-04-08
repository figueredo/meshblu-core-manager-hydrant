uuid                  = require 'uuid'
HydrantManager        = require '..'
HydrantManagerFactory = require '../factory'

describe 'HydrantManagerFactory', ->
  beforeEach ->
    @redisKey = uuid.v1()
    @uuidAliasResolver = resolve: (uuid, callback) => callback(null, uuid)

    @sut = new HydrantManagerFactory {
      @uuidAliasResolver
      namespace: 'something'
      redisUri: 'redis://localhost'
    }

  describe 'build', ->
    beforeEach ->
      @hydrantManager = @sut.build()

    it 'should create a HydrantManager', ->
      expect(@hydrantManager).to.be.an.instanceOf HydrantManager
