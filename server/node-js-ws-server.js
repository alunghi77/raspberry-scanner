// Generated by CoffeeScript 1.3.3
(function() {
  var WebSocketServer, acceptDomain, clients, http, server, webSocketsServerPort, wsServer;

  webSocketsServerPort = 1337;

  acceptDomain = 'http://sandbox.dev:10088';

  clients = [];

  WebSocketServer = require('websocket').server;

  http = require('http');

  server = http.createServer(function(request, response) {});

  server.listen(webSocketsServerPort, function() {
    return console.log(new Date() + "[Welcome to Raspberry Scanner] Server is listening on port " + webSocketsServerPort);
  });

  wsServer = new WebSocketServer({
    httpServer: server
  });

  wsServer.on("request", function(request) {
    var connection, index;
    console.log(new Date() + ' Connection from origin ' + request.origin + '.');
    connection = request.accept(null, request.origin);
    index = clients.push(connection) - 1;
    console.log(new Date() + ' Connection accepted.');
    connection.on("message", function(message) {
      var client, currentMsg, d, formatDate, messageSendObj, _i, _len, _results;
      if (message.type === "utf8") {
        formatDate = function(date) {
          var normalisedDate;
          normalisedDate = new Date(date - (date.getTimezoneOffset() * 60 * 1000));
          return normalisedDate.toISOString();
        };
        d = new Date();
        currentMsg = {};
        currentMsg["time_ago"] = formatDate(new Date());
        currentMsg["text"] = message.utf8Data;
        currentMsg["fullname"] = "scanner";
        currentMsg["color"] = "color";
        messageSendObj = {};
        messageSendObj["type"] = "message";
        messageSendObj["data"] = currentMsg;
        _results = [];
        for (_i = 0, _len = clients.length; _i < _len; _i++) {
          client = clients[_i];
          _results.push(client.sendUTF(JSON.stringify(messageSendObj)));
        }
        return _results;
      }
    });
    return connection.on("close", function(connection) {});
  });

}).call(this);
