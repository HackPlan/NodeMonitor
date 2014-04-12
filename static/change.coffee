socket = io.connect("http://lochost/")
socket.on "os", (data) ->
  $('#hostname').html(data.hostname)
  $('#system').html(data.type + " " + data.release)
  $('#cpus').html(data.cpus)
  $('#servertime').html(data.servertime)
  $('#uptime').html(data.uptime)
  $('#loadavg').html(data.loadavg)

socket.on "mem", (data) ->
  $('#totalMem').html(data.totalMem)
  $('#realMem').html(data.realMem)
  $('#cachedMem').html(data.cachedMem)
  $('#realMemPer').attr("style","width: " + data.realMemPer + "%;")
  $('#realMemPer').text("real " + data.realMemPer  + " %")
  $('#cachedMemPer').attr("style","width: " + data.cachedMemPer + "%;")
  $('#cachedMemPer').text("cached " + data.cachedMemPer  + " %")
  $('#freeMemPer').attr("style","width: " + data.freeMemPer + "%;")
  $('#freeMemPer').text("free " + data.freeMemPer  + " %")
  $('#swaptotalMem').html(data.swaptotalMem)
  $('#swapUsedMem').html(data.swapUsedMem)
  $('#swapUsedMemPer').attr("style","width: " + data.swapUsedMemPer + "%;")
  $('#swapUsedMemPer').text("swapUsed " + data.swapUsedMemPer  + " %")
  $('#swapFreeMem').html(data.swapFreeMem)
  $('#swapFreeMemPer').attr("style","width: " + data.swapFreeMemPer + "%;")
  $('#swapFreeMemPer').text("swapFree " + data.swapFreeMemPer  + " %")

socket.on "disk", (data) ->
  $('#diskAll').html(data.diskAll)
  $('#diskUsed').html(data.diskUsed)
  $('#diskUsedPer').attr("style","width: " + data.diskUsedPer + "%;")
  $('#diskUsedPer').text("diskUsed " + data.diskUsedPer  + " %")
  $('#diskFreePer').attr("style","width: " + data.diskFreePer + "%;")
  $('#diskFreePer').text("diskFree " + data.diskFreePer  + " %")

socket.on "ps", (data) ->
  psuser = psall = ""
  for user of data["user"]
    psuser += ("<tr><td>"+user+"</td><td>"+data["user"][user].procNum+"</td><td>"+data["user"][user].cpuPer.toFixed(1)+"%</td><td>"+(data["user"][user].realMem/1024).toFixed(1)+" MB ("+data["user"][user].memPer.toFixed(1)+"%)</td><td>"+(data["user"][user].swapMem/1024).toFixed(1)+" MB</td></tr>")
  $("#psuser").html(psuser)
  for i of data["all"]
    psall += ("<tr><td>"+data["all"][i][0]+"</td><td>"+data["all"][i][1]+"</td><td>"+data["all"][i][2]+"</td><td>"+data["all"][i][3]+"</td><td>"+data["all"][i][4]+"</td><td>"+data["all"][i][5]+"</td><td>"+data["all"][i][6]+"</td><td>"+data["all"][i][7]+"</td><td>"+data["all"][i][8]+"</td><td>"+data["all"][i][9]+"</td><td>"+data["all"][i][10]+"</td></tr>")
  $("#psall").html(psall)
