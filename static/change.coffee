socket = io.connect("http://you.site/")
socket.on "data", (data) ->
  $('#hostname').html(data.os.hostname)
  $('#system').html(data.os.type + " " + data.os.release)
  $('#cpus').html('<abbr title="' + data.os.cpus + '">' + data.os.cpus + '</abbr>')
  startTime(data.os.servertime)
  $('#uptime').html(data.os.uptime)
  $('#loadavg').html(data.os.loadavg)

  $('#totalMem').html(data.mem.totalMem)
  $('#realMem').html(data.mem.realMem)
  $('#cachedMem').html(data.mem.cachedMem)
  $('#realMemPer').attr("style","width: " + data.mem.realMemPer + "%;")
  $('#realMemPer').text("real " + data.mem.realMemPer  + " %")
  $('#cachedMemPer').attr("style","width: " + data.mem.cachedMemPer + "%;")
  $('#cachedMemPer').text("cached " + data.mem.cachedMemPer  + " %")
  $('#freeMemPer').attr("style","width: " + data.mem.freeMemPer + "%;")
  $('#freeMemPer').text("free " + data.mem.freeMemPer  + " %")
  $('#swaptotalMem').html(data.mem.swaptotalMem)
  $('#swapUsedMem').html(data.mem.swapUsedMem)
  $('#swapUsedMemPer').attr("style","width: " + data.mem.swapUsedMemPer + "%;")
  $('#swapUsedMemPer').text("swapUsed " + data.mem.swapUsedMemPer  + " %")
  $('#swapFreeMem').html(data.mem.swapFreeMem)
  $('#swapFreeMemPer').attr("style","width: " + data.mem.swapFreeMemPer + "%;")
  $('#swapFreeMemPer').text("swapFree " + data.mem.swapFreeMemPer  + " %")

  $('#diskAll').html(data.disk.diskAll)
  $('#diskUsed').html(data.disk.diskUsed)
  $('#diskUsedPer').attr("style","width: " + data.disk.diskUsedPer + "%;")
  $('#diskUsedPer').text("diskUsed " + data.disk.diskUsedPer  + " %")
  $('#diskFreePer').attr("style","width: " + data.disk.diskFreePer + "%;")
  $('#diskFreePer').text("diskFree " + data.disk.diskFreePer  + " %")

  psuser = psall = ""
  for user of data.ps["user"]
    psuser += ("<tr><td>"+user+"</td><td>"+data.ps["user"][user].procNum+"</td><td>"+data.ps["user"][user].cpuPer.toFixed(1)+"%</td><td>"+(data.ps["user"][user].realMem/1024).toFixed(1)+" MB ("+data.ps["user"][user].memPer.toFixed(1)+"%)</td><td>"+(data.ps["user"][user].swapMem/1024).toFixed(1)+" MB</td></tr>")
  $("#psuser").html(psuser)
  for i of data.ps["all"]
    psall += ("<tr><td>"+data.ps["all"][i][0]+"</td><td>"+data.ps["all"][i][1]+"</td><td>"+data.ps["all"][i][2]+"</td><td>"+data.ps["all"][i][3]+"</td><td>"+data.ps["all"][i][4]+"</td><td>"+data.ps["all"][i][5]+"</td><td>"+data.ps["all"][i][6]+"</td><td>"+data.ps["all"][i][7]+"</td><td>"+data.ps["all"][i][8]+"</td><td>"+data.ps["all"][i][9]+'</td><td><abbr title="' + data.ps["all"][i][10] + '">' + data.ps["all"][i][10] + "</abbr></td></tr>")
  $("#psall").html(psall)

startTime = (servertime)->
  setTime new Date servertime
  setTimeout ->
    time = new Date servertime
    time.setSeconds time.getSeconds() + 1
    setTime time
  , 1000
  setTimeout ->
    time = new Date servertime
    time.setSeconds time.getSeconds() + 2
    setTime time
  , 2000
  setTimeout ->
    time = new Date servertime
    time.setSeconds time.getSeconds() + 3
    setTime time
  , 3000
  setTimeout ->
    time = new Date servertime
    time.setSeconds time.getSeconds() + 4
    setTime time
  , 4000

setTime = (time)->
  hours = checkTime time.getHours()
  minutes = checkTime time.getMinutes()
  seconds = checkTime time.getSeconds()
  $('#servertime').html(time.getFullYear() + "-" + (time.getMonth() + 1) + "-" + time.getDate() + " " + hours + ":" + minutes + ":" + seconds)

checkTime = (i) ->
  return "0" + i  if i < 10
  return i