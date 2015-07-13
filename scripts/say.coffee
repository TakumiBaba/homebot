Linda = require 'linda'

module.exports = (robot) ->

  io = require('socket.io-client').connect 'http://localhost:8931'
  linda = new Linda.Client().connect io
  linda.io.on 'connect', ->
    console.log('----connect----')

  robot.respond /say (.*)/i, (msg) ->
    message = msg.match[1]
    console.log(linda.io)
    ts = linda.tuplespace 'takumibaba'
    ts.write {type : 'say', message : message}
    ts.take {type : 'result', action : 'say', response : 'success'}, ->
      msg.reply "baba に #{message} と言っておいた"
