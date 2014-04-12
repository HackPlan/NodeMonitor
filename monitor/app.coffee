http = require 'http'
url = require 'url'
fs = require 'fs'

Monitor = require './Monitor'

exports.runWebServer = ->
  app = http.createServer (req, res) ->
    reqfile = url.parse(req.url).pathname.slice(1).match(/[a-zA-Z0-9_ -.]+/) ? 'index.html'
    fs.readFile '../static/' + reqfile, (err, data) ->
      if err
        res.writeHead 500
        return res.end('Error loading ' + reqfile)

      res.writeHead 200
      res.end(data)

  app.listen 3000

  return app

exports.runWebSocket = (port) ->
  io = require('socket.io').listen port

  io.sockets.on 'connection', (socket) ->
    sendData = ->
      Monitor.osData socket

    sendData()
    setInterval sendData, 1000

    socket.on 'disconnect', ->
      clearTimeout intervalId

unless module.parent
  app = exports.runWebServer()
  exports.runWebSocket app