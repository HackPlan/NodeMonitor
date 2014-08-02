app = angular.module("main", ["angular-table", "ngSanitize", "ui.bootstrap"])

.controller("MainCtrl", ["$scope", "$sce", ($scope, $sce) ->

  $scope.trustAsHtml = (d) ->
    $sce.trustAsHtml d

  $scope.loading = true

  socket = io.connect(":2957")
  socket.on "data", (d) ->
    # System
    $scope.system = d.os
    # User
    psUser = []
    for name, userData of d.ps["user"]
      oneUser =
        USER: name
        PS: userData["procNum"]
        CPU: userData["cpuPer"]
        MEM: userData["memPer"]
        SWAP: userData["swapMem"]
      psUser.push oneUser
    $scope.psUser = psUser
    # Process
    psAll = []
    for index, processData of d.ps["all"]
      oneProcess = _.zipObject ["USER", "PID", "CPU", "MEM", "VSZ", "RES", "TTY", "STAT", "START", "TIME", "COMMAND"], processData
      for k in ["VSZ", "MEM", "CPU", "PID", "RES"]
        oneProcess[k] = parseFloat oneProcess[k]
      psAll.push oneProcess
    $scope.psAll = psAll
    # Memory and Disk
    $scope.mem = d.mem
    $scope.disk = d.disk

    $scope.$apply()
    $scope.loading = false
])

.filter('fixToOne', ->
  (d) ->
    d.toFixed(1)
)

.filter('mb', ->
  (d) ->
    (d/1024).toFixed(1)
)

.filter('nbsp', ->
  (d) ->
    d.replace(/&nbsp;/g, ' ')
)
