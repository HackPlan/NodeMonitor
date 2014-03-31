var data = new Array();

var child_process = require("child_process");
var os = require("os");

function osData() {
    mins = os.uptime() / 60;
    hours = mins / 60;
    days = Math.floor(hours / 24);
    hours = Math.floor(hours - (days * 24));
    min = Math.floor(mins - (days * 60 * 24) - (hours * 60));
    uptimeStr = "";
    if (days)
        uptimeStr = days + " days ";
    if (hours)
        uptimeStr += hours + " hours ";
    uptimeStr += min + " mins";

    var Today = new Date();
    data['os'] = {
        'hostname': os.hostname(),
        'type': os.type(),
        'release': os.release(),
        'cpus': os.cpus()[0]['model'],
        'servertime': Today.getFullYear() + "-" + (Today.getMonth() + 1) + "-" + Today.getDate() + " " + Today.getHours() + "：" + Today.getMinutes() + "：" + Today.getSeconds(),
        'uptime': uptimeStr,
        'loadavg': os.loadavg(),
    }
    console.log(data['os']);
}
function memData() {
    child_process.exec(
        "free -m", {},
        function (error, stdout, stderr) {
            var rePattern = /Mem:\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+.+cache:\s+(\d+)\s+(\d+)\s+Swap:\s+(\d+)\s+(\d+)\s+(\d+)/;
            var memInfo = rePattern.exec(stdout);
            var realMemUsed = memInfo[2] - memInfo[4] - memInfo[5] - memInfo[6];
            var buffersMemPer = Math.round(memInfo[5] / memInfo[1] * 100);
            var realMemPer = Math.round(realMemUsed / memInfo[1] * 100);
            var cachedMemPer = Math.round(memInfo[6] / memInfo[1] * 100);

            data['mem'] = {
                'realMemPer': realMemPer,
                'cachedMemPer': cachedMemPer,
                'freeMemPer': (100 - realMemPer - cachedMemPer - buffersMemPer),
                'swapUsedMemPer': Math.round(memInfo[10] / memInfo[9] * 100),
            }
            console.log(data['mem']);
        }
    );
}
function psData() {
    child_process.exec("ps xufwa",
        {},
        function (error, stdout, stderr) {
            var userInfo = {'user': {}, 'all': {}};
            var psArray = stdout.split("\n");

            for (i = 1; i < (psArray.length - 1); i++) {
                var vpsArrayInfo = psArray[i];
                while (psArray[i].match("  "))
                    psArray[i] = psArray[i].replace("  ", " ");
                var procArray = psArray[i].split(" ");

                var allprocArray = [];
                for (j = 0; j < procArray.length; j++) {
                    if (j < 10) {
                        allprocArray[j] = procArray[j];
                    } else {
                        allprocArray[10] = vpsArrayInfo.substr(64)
                            .replace(/&/g, "&amp;")
                            .replace(/</g, "&lt;")
                            .replace(/>/g, "&gt;")
                            .replace(/"/g, "&quot;")
                            .replace(/'/g, "&#039;")
                            .replace(" ", "&nbsp;");
                    }
                }
                userInfo['all'][i - 1] = allprocArray;

                if (typeof userInfo['user'][procArray[0]] === 'undefined') {
                    userInfo['user'][procArray[0]] = {
                        "cpuPer": 0,
                        "memPer": 0,
                        "swapMem": 0,
                        "realMem": 0,
                        "procNum": 0,
                    }
                }

                var numbers = ["cpuPer", "memPer", "swapMem", "realMem"];
                numbers.forEach(function (item, index, array) {
                    userInfo['user'][procArray[0]][item] += Number(procArray[index + 2]);
                });
                userInfo['user'][procArray[0]]["procNum"] += 1;
            }
            console.log(userInfo);
        }
    );
}
function diskData() {
    child_process.exec(
        "df", {},
        function (error, stdout, stderr) {
            var dkArray = stdout.split("\n");
            var diskAll = diskUsed = diskRate = 0;
            for (i = 1; i < (dkArray.length - 1); i++) {
                while (dkArray[i].match("  "))
                    dkArray[i] = dkArray[i].replace("  ", " ");
                var dkArrayInfo = dkArray[i].split(" ");
                diskAll += Number(dkArrayInfo[1]);
                diskUsed += Number(dkArrayInfo[2]);
            }
            diskRate = Math.round(diskUsed / diskAll * 100) + " %";
            console.log(diskRate);
        }
    );
}
osData();
memData();
psData();
diskData();