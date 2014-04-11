socket = io.connect("http://localhost")
socket.on "os", (data) ->
  $('#hostname').html(data.hostname)
  $('#system').html(data.type + " " + data.release)
  $('#cpus').html(data.cpus)
  $('#servertime').html(data.servertime)
  $('#uptime').html(data.uptime)
  $('#loadavg').html(data.loadavg)
