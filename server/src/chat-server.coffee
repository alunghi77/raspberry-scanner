# ws-scanner server

webSocketsServerPort = 1337
acceptDomain = 'http://sandbox.dev:10088'

# list of currently connected clients (users)
clients = [ ]

WebSocketServer = require('websocket').server
http = require('http')

server = http.createServer (request, response) ->

	#process HTTP request. Since we're writing just WebSockets server
	# we don't have to implement anything.

server.listen webSocketsServerPort, ()-> 

	console.log new Date() + "[Welcome to Raspberry Scanner] Server is listening on port " + webSocketsServerPort

# create the server
wsServer = new WebSocketServer({

	httpServer: server

})

# WebSocket server
wsServer.on "request", (request) ->

	console.log new Date() + ' Connection from origin ' + request.origin + '.'

	# if request.origin isnt acceptDomain

	# 	console.log "Cannot connect from a different host"

	# 	return false

	connection = request.accept(null, request.origin)

	# add client to array
	index = clients.push( connection ) - 1

	console.log new Date() + ' Connection accepted.'

	# This is the most important callback for us, we'll handle
	# all messages from users here.

	connection.on "message", (message) ->

		# accept only text
		if message.type is "utf8"

			# process WebSocket message
			currentMsg = {}
			currentMsg["time_ago"] 	= (new Date()).getTime()
			currentMsg["text"] 		= message.utf8Data
			currentMsg["fullname"] 	= "user"
			currentMsg["color"] 	= "color"

			messageSendObj = {}
			messageSendObj["type"] = "message"
			messageSendObj["data"] = currentMsg

			# distribute current msg to current users

			for client in clients

				client.sendUTF JSON.stringify messageSendObj

	connection.on "close", (connection) ->

		# close user connection