Linda = require 'linda'

module.exports = (robot) ->

  io = require('socket.io-client').connect 'https://baba-house-linda.herokuapp.com'
  client = new Linda.Client().connect io

  robot.respond /aircon (on|off)/i, (msg) ->
    action = msg.match[1]
    ts = client.tuplespace 'irkit'
    ts.write {type: 'aircon', action: action}
    ts.take {type: 'resullt', action: "aircon_#{action}"}, (err, tuple) ->
      msg.reply tuple.data.value
