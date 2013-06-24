# https://github.com/flatiron/prompt and https://github.com/qrpike/NodeJS-CLI-Listener

WebSocket 	= require('ws')
sys = require("sys")

endpoint = 'ws://192.168.1.116:1337'

st = process.openStdin()

st.addListener "data", (d) ->

	sys.print("Sending...\n")

	WebSocket = require('ws');

	ws = new WebSocket(endpoint);
	
	ws.on 'open', () ->

		ws.send(d)

	ws.on 'message', (data, flags) ->

		# flags.binary will be set if a binary data is received
		# flags.masked will be set if the data was masked
		
	sys.print("Scan Barcode : ")
		
sys.print("Scan Barcode : ")
