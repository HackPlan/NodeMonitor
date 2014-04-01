osData = ->
  mins = os.uptime() / 60
  hours = mins / 60
  days = Math.floor(hours / 24)
  hours = Math.floor(hours - (days * 24))
  min = Math.floor(mins - (days * 60 * 24) - (hours * 60))
  uptimeStr = ""
  uptimeStr = days + " days "  if days
  uptimeStr += hours + " hours "  if hours
  uptimeStr += min + " mins"
  Today = new Date()
  data["os"] =
    hostname: os.hostname()
    type: os.type()
    release: os.release()
    cpus: os.cpus()[0]["model"]
    servertime: Today.getFullYear() + "-" + (Today.getMonth() + 1) + "-" + Today.getDate() + " " + Today.getHours() + "：" + Today.getMinutes() + "：" + Today.getSeconds()
    uptime: uptimeStr
    loadavg: os.loadavg()

  console.log data["os"]
  return
memData = ->
  child_process.exec "free -m", {}, (error, stdout, stderr) ->
    rePattern = /Mem:\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+.+cache:\s+(\d+)\s+(\d+)\s+Swap:\s+(\d+)\s+(\d+)\s+(\d+)/
    memInfo = rePattern.exec(stdout)
    realMemUsed = memInfo[2] - memInfo[4] - memInfo[5] - memInfo[6]
    buffersMemPer = Math.round(memInfo[5] / memInfo[1] * 100)
    realMemPer = Math.round(realMemUsed / memInfo[1] * 100)
    cachedMemPer = Math.round(memInfo[6] / memInfo[1] * 100)
    data["mem"] =
      realMemPer: realMemPer
      cachedMemPer: cachedMemPer
      freeMemPer: (100 - realMemPer - cachedMemPer - buffersMemPer)
      swapUsedMemPer: Math.round(memInfo[10] / memInfo[9] * 100)

    console.log data["mem"]
    return

  return
psData = ->
  child_process.exec "ps xufwa", {}, (error, stdout, stderr) ->
    userInfo =
      user: {}
      all: {}

    psArray = stdout.split("\n")
    i = 1
    while i < (psArray.length - 1)
      vpsArrayInfo = psArray[i]
      psArray[i] = psArray[i].replace("  ", " ")  while psArray[i].match("  ")
      procArray = psArray[i].split(" ")
      allprocArray = []
      j = 0
      while j < procArray.length
        if j < 10
          allprocArray[j] = procArray[j]
        else
          allprocArray[10] = vpsArrayInfo.substr(64).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g,
            "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;").replace(" ", "&nbsp;")
        j++
      userInfo["all"][i - 1] = allprocArray
      if typeof userInfo["user"][procArray[0]] is "undefined"
        userInfo["user"][procArray[0]] =
          cpuPer: 0
          memPer: 0
          swapMem: 0
          realMem: 0
          procNum: 0
      numbers = [
        "cpuPer"
        "memPer"
        "swapMem"
        "realMem"
      ]
      numbers.forEach (item, index, array) ->
        userInfo["user"][procArray[0]][item] += Number(procArray[index + 2])
        return

      userInfo["user"][procArray[0]]["procNum"] += 1
      i++
    console.log userInfo
    return

  return
diskData = ->
  child_process.exec "df", {}, (error, stdout, stderr) ->
    dkArray = stdout.split("\n")
    diskAll = diskUsed = diskRate = 0
    i = 1
    while i < (dkArray.length - 1)
      dkArray[i] = dkArray[i].replace("  ", " ")  while dkArray[i].match("  ")
      dkArrayInfo = dkArray[i].split(" ")
      diskAll += Number(dkArrayInfo[1])
      diskUsed += Number(dkArrayInfo[2])
      i++
    diskRate = Math.round(diskUsed / diskAll * 100) + " %"
    console.log diskRate
    return

  return

data = new Array()
child_process = require("child_process")
os = require("os")
osData()
memData()
psData()
diskData()