{EventEmitter2} = require 'eventemitter2'

class MultiHydrantManager extends EventEmitter2
  constructor: ({@client, @uuidAliasResolver}) ->
    throw new Error('MultiHydrantManager: client is required') unless @client?
    throw new Error('MultiHydrantManager: uuidAliasResolver is required') unless @uuidAliasResolver?

  connect: (callback) =>
    @client.once 'ready', =>
      @client.on 'message', @_onMessage
      callback()
      callback = ->

    @client.once 'error', (error) =>
      callback error
      callback = ->

  subscribe: ({uuid}, callback) =>
    @uuidAliasResolver.resolve uuid, (error, uuid) =>
      return callback error if error?
      @client.subscribe uuid, callback

  close: =>
    if @client.disconnect?
      @client.quit()
      @client.disconnect false
      return
    @client.end true

  _onMessage: (channel, messageStr) =>
    try
      message = JSON.parse messageStr
    catch
      @emit 'error', 'Error: unable to parse message'
      return

    @emit 'message', channel, message

module.exports = MultiHydrantManager
