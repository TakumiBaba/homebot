Linda = require 'linda'

module.exports = (robot) ->

  io = require('socket.io-client').connect 'http://localhost:8931'
  client = new Linda.Client().connect io

  robot.respond /aircon (on|off)/i, (msg) ->
    action = msg.match[1]
    ts = client.tuplespace 'takumibaba'
    ts.write {type: 'aircon', action: action}
    ts.take {type: 'result', action: "aircon_#{action}"}, (err, tuple) ->
      if tuple.data.status is 'failure'
        msg.reply 'ダメだったよ...'
      else if tuple.data.status is 'success'
        msg.reply tuple.data.status

  robot.respond /tv (on|off)/i, (msg) ->
    action = msg.match[1]
    ts = client.tuplespace 'takumibaba'
    ts.write {type: 'tv', action: action}
    ts.take {type: 'result', action: "tv_#{action}"}, (err, tuple) ->
      if tuple.data.status is 'failure'
        msg.reply 'ダメだったよ...'
      else if tuple.data.status is 'success'
        msg.reply tuple.data.status

  robot.respond /light (.*) (on|off)/i, (msg) ->
    id = parseInt(msg.match[1], 10) - 1
    action = msg.match[2]
    ts = client.tuplespace 'takumibaba'
    ts.write {type: 'light', action: action, id : id}
    ts.take {type: 'result', action: "light_#{action}"}, (err, tuple) ->
      if tuple.data.status is 'failure'
        msg.reply 'ダメだったよ...'
      else if tuple.data.status is 'success'
        if tuple.data.action is 'light_on'
          msg.reply "電気つけた！！"
        else if tuple.data.action is 'light_off'
          msg.reply "電気けした！！"

  robot.respond /roomba (ignition|go_home)/i, (msg) ->
    action = msg.match[1]
    ts = client.tuplespace 'takumibaba'
    ts.write {type: 'roomba', action: action}
    ts.take {type: 'result', action: "roomba_#{action}"}, (err, tuple) ->
      if tuple.data.status is 'failure'
        msg.reply 'ダメだったよ...'
      else if tuple.data.status is 'success'
        if tuple.data.action is 'roomba_ignition'
          msg.reply "行け！！ルンバ！！"
        else if tuple.data.action is 'roomba_go_home'
          msg.reply "ルンバ、お家へ帰る"
