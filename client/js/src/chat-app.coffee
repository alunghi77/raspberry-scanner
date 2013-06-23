# Chat app
# http://martinsikora.com/nodejs-and-websocket-simple-chat-tutorial
# 
# Create a chat item
#
create_chat = (msg) ->

	# render
	template 	= Handlebars.compile $("#chatItem-tmpl").html()
	html 	 	= $.trim template {"msg":msg }	

	# display

	$(".chat-scroller").mCustomScrollbar("update")

	$(".chat-scroller .mCSB_container").append(html)

	$(".chat-scroller").mCustomScrollbar("scrollTo","bottom",{scrollInertia:250,scrollEasing:"easeInOutQuad"})

	false

# 
# Chat websocket
#
chat = ()->

	input 	= $("#form_chat")
	status 	= $(".status h4")

	status.closest(".status").slideUp "fast"

	# if user is running mozilla then use it's built-in WebSocket
	window.WebSocket = window.WebSocket || window.MozWebSocket

	# if browser doesn't support WebSocket, just show some notification and exit
	if !window.WebSocket
		
		status.html($('<p>', { text: 'Sorry, but your browser doesn\'t support WebSockets.'} ))
		
		return
	
	connection = new WebSocket 'ws://127.0.0.1:1337'

	connection.onopen = () ->

		#connection is opened and ready to use
		status.closest(".status").removeClass("alert-error").addClass("alert-success")
		status.closest(".status").slideDown "fast"
		status.html('<i class="icon-ok"></i> Success - You are connected.')
		status.closest(".status").delay(3000).slideUp "slow"

		input.removeAttr('disabled')

	connection.onerror = (error) ->

		# an error occurred when sending/receiving data
		status.html($('<p>', { text: 'Sorry, but there\'s some problem with your connection or the server is down.' } ))

	connection.onmessage = (message) ->

		# try to decode json (I assume that each message from server is json)
		try 
			
			currentMsg = JSON.parse message.data
		
		catch e

			console.log 'This doesn\'t look like a valid JSON: ', message.data
		
		# handle incoming message

		# it's a single message
		if currentMsg.type is "message" 

			input.removeAttr('disabled');
			
			create_chat currentMsg

		else

			console.log('Hmm..., I\'ve never seen JSON like this: ', json);


	# Send mesage when user presses Enter key
	input.keydown (e) ->

		if e.keyCode is 13

			msg = $(@).val()

			if !msg

				return

			# send the message as an ordinary text
			connection.send msg

			$(@).val('')

			# disable the input field to make the user wait until server
			# sends back response

			input.attr('disabled', 'disabled');

			# we know that the first message sent from a user their name
			if myName is false

				myName = msg


	#
	# This method is optional. If the server wasn't able to respond to the
	# in 3 seconds then show some error message to notify the user that
	# something is wrong.
	#
	setInterval () ->

		if connection.readyState isnt 1

			status.closest(".status").removeClass("alert-success").addClass("alert-error")
			status.closest(".status").slideDown "fast"
			status.html('<i class="icon-warning-sign"></i> Error - Unable to communicate with the chat server.')
			input.attr('disabled', 'disabled')

	, 3000

$ ->

	chat()

	if $(".chat-scroller").length > 0

		$(".chat-scroller").mCustomScrollbar {
			scrollButtons:{
				enable:true
			}
		}
