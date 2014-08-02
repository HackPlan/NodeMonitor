var app;

app = angular.module("main", ["angular-table", "ngSanitize", "ui.bootstrap"]).controller("MainCtrl", [
  "$scope", "$sce", function($scope, $sce) {
    var socket;
    $scope.trustAsHtml = function(d) {
      return $sce.trustAsHtml(d);
    };
    $scope.loading = true;
    socket = io.connect(":2957");
    return socket.on("data", function(d) {
      var index, k, name, oneProcess, oneUser, processData, psAll, psUser, userData, _i, _len, _ref, _ref1, _ref2;
      $scope.system = d.os;
      psUser = [];
      _ref = d.ps["user"];
      for (name in _ref) {
        userData = _ref[name];
        oneUser = {
          USER: name,
          PS: userData["procNum"],
          CPU: userData["cpuPer"],
          MEM: userData["memPer"],
          SWAP: userData["swapMem"]
        };
        psUser.push(oneUser);
      }
      $scope.psUser = psUser;
      psAll = [];
      _ref1 = d.ps["all"];
      for (index in _ref1) {
        processData = _ref1[index];
        oneProcess = _.zipObject(["USER", "PID", "CPU", "MEM", "VSZ", "RES", "TTY", "STAT", "START", "TIME", "COMMAND"], processData);
        _ref2 = ["VSZ", "MEM", "CPU", "PID", "RES"];
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          k = _ref2[_i];
          oneProcess[k] = parseFloat(oneProcess[k]);
        }
        psAll.push(oneProcess);
      }
      $scope.psAll = psAll;
      $scope.mem = d.mem;
      $scope.disk = d.disk;
      $scope.$apply();
      return $scope.loading = false;
    });
  }
]).filter('fixToOne', function() {
  return function(d) {
    return d.toFixed(1);
  };
}).filter('mb', function() {
  return function(d) {
    return (d / 1024).toFixed(1);
  };
}).filter('nbsp', function() {
  return function(d) {
    return d.replace(/&nbsp;/g, ' ');
  };
});
