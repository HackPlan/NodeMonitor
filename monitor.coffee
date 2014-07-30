child_process = require("child_process")
os = require("os")
monitor = {}

monitor.osData = (cb) ->
  osData = {}
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
  loadavg = os.loadavg()
  loadavg_str = ""
  for name, i in loadavg
    loadavg_str += loadavg[i].toFixed(2) + " "
  osData["os"] =
    hostname: os.hostname()
    type: os.type()
    release: os.release()
    cpus: os.cpus()[0]["model"]
    servertime: Today.getFullYear() + "-" + (Today.getMonth() + 1) + "-" + Today.getDate() + " " + Today.getHours() + ":" + Today.getMinutes() + ":" + Today.getSeconds()
    uptime: uptimeStr
    loadavg: loadavg_str
  cb osData["os"]

monitor.memData = (cb) ->
  memData = {}
  child_process.exec "free -m", {}, (error, stdout) ->
    rePattern = /Mem:\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+.+cache:\s+(\d+)\s+(\d+)\s+Swap:\s+(\d+)\s+(\d+)\s+(\d+)/
    memInfo = rePattern.exec(stdout)
    realMemUsed = memInfo[2] - memInfo[4] - memInfo[5] - memInfo[6]
    buffersMemPer = Math.round(memInfo[5] / memInfo[1] * 100)
    realMemPer = Math.round(realMemUsed / memInfo[1] * 100)
    cachedMemPer = Math.round(memInfo[6] / memInfo[1] * 100)
    memData["mem"] =
      totalMem: memInfo[1] + "M"
      realMem: memInfo[2] + "M"
      cachedMem: memInfo[6] + "M"
      realMemPer: realMemPer
      cachedMemPer: cachedMemPer + buffersMemPer
      freeMemPer: (100 - realMemPer - cachedMemPer - buffersMemPer)
      swaptotalMem: memInfo[9] + "M"
      swapUsedMemPer: Math.round(memInfo[10] / memInfo[9] * 100)
      swapFreeMemPer: Math.round((memInfo[9] - memInfo[10]) / memInfo[9] * 100)
      swapUsedMem: memInfo[10] + "M"
    cb memData["mem"]

monitor.psData = (cb) ->
  psData = {}
  child_process.exec "ps xufwa", {}, (error, stdout) ->
    psData['ps'] =
      user: {}
      all: {}

    psArray = stdout.split("\n")
    i = 1
    while i < (psArray.length - 1)
      vpsArrayInfo = psArray[i]
      psArray[i] = psArray[i].replace("  ", " ") while psArray[i].match("  ")
      procArray = psArray[i].split(" ")
      allprocArray = []
      j = 0
      while j < procArray.length
        if j < 10
          allprocArray[j] = procArray[j]
        else
          allprocArray[10] = vpsArrayInfo.substr(64)
          allprocArray[10] = allprocArray[10].replace(" ", "&nbsp;") while allprocArray[10].match(" ")
        j++
      psData['ps']["all"][i - 1] = allprocArray
      if typeof psData['ps']["user"][procArray[0]] is "undefined"
        psData['ps']["user"][procArray[0]] =
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
      numbers.forEach (item, index) ->
        psData['ps']["user"][procArray[0]][item] += Number(procArray[index + 2])
      psData['ps']["user"][procArray[0]]["procNum"] += 1
      i++
    cb psData['ps']

monitor.diskData = (cb) ->
  diskData = {}
  child_process.exec "df", {}, (error, stdout) ->
    dkArray = stdout.split("\n")
    dkArray[1] = dkArray[1].replace("  ", " ") while dkArray[1].match("  ")
    dkArrayInfo = dkArray[1].split(" ")

    diskData["disk"] =
      diskUsedPer: Math.round(Number(dkArrayInfo[2]) / Number(dkArrayInfo[1]) * 100)
      diskFreePer: 100 - Math.round(Number(dkArrayInfo[2]) / Number(dkArrayInfo[1]) * 100)
      diskAll: Math.round(Number(dkArrayInfo[1]) / 1048576) + "G"
      diskUsed: Math.round(Number(dkArrayInfo[2]) / 1048576) + "G"
    cb diskData["disk"]

module.exports = monitor