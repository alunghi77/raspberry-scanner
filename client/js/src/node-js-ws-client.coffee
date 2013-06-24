# https://github.com/flatiron/prompt and https://github.com/qrpike/NodeJS-CLI-Listener

WebSocket 	= require('ws')

sys = require("sys")

st = process.openStdin()

st.addListener "data", (d) ->

	sys.print("Sending...\n")

	WebSocket = require('ws');

	ws = new WebSocket('ws://192.168.1.5:1337');
	
	ws.on 'open', () ->

		ws.send(d)

	ws.on 'message', (data, flags) ->

		# flags.binary will be set if a binary data is received
		# flags.masked will be set if the data was masked
		
	sys.print("Scan Barcode : ")
		
sys.print("Scan Barcode : ")