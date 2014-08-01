http = require 'http'
url = require 'url'
fs = require 'fs'
_ = require 'underscore'
monitor = require './monitor'

global = this
global.sockets = []

sendData = ->
  if global.sockets.length > 0
    monitor.osData (osData)->
      monitor.memData (memData)->
        monitor.psData (psData)->
          monitor.diskData (diskData)->
            Data =
              "os": osData
              "mem": memData
              "ps": psData
              "disk": diskData
            _.each global.sockets, (socket)->
              socket.emit("data", Data)

setInterval sendData, 5000

exports.runWebServer = ->
  app = http.createServer (req, res) ->
    reqfile = url.parse(req.url).pathname.slice(1).match(/[a-zA-Z0-9_ -.]+/) ? 'index.html'
    fs.readFile __dirname + '/static/' + reqfile, (err, data) ->
      if err
        res.writeHead 500
        return res.end('Error loading ' + reqfile)
      res.writeHead 200
      res.end data
  app.listen 2957
  return app

exports.runWebSocket = (app) ->
  io = require('socket.io').listen app,
    log: false
  io.sockets.on 'connection', (socket) ->
    global.sockets.push socket
    socket.on 'disconnect', ->
      sockets_new = []
      _.each global.sockets, (socket_new)->
        if socket_new.id != socket.id
          sockets_new.push socket_new
      global.sockets = sockets_new

unless module.parent
  app = exports.runWebServer()
  exports.runWebSocket app