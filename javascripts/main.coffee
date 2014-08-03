
window.controller = new Leap.Controller({
  background: true,
  checkVersion: false
});

# note: this won't work w/o custom server.
controller.use('networking', {
  peer: new Peer({
    secure: true
    key: 'ah7pg4vez7kz9f6r'
  }),
});

# custom fork of riggedHand - one which would select which scene to put a hand in, based off of userID?
controller.use('riggedHand', {
  scale: 1.5
});

controller.on 'riggedHand.handFound', (skinnedMesh)->
  console.log 'hand found'
  skinnedMesh.transparent = false


window.riggedHand = controller.plugins.riggedHand
window.canvas = controller.plugins.riggedHand.renderer.domElement

window.canvasHeight = 120

# set up canvas
canvas.style.width = "100%"
canvas.style.height = "#{canvasHeight}px"
canvas.style.background = "rgba(0,0,0,0.8)"
canvas.style.zIndex = "-1"
canvas.style.position = "absolute"
canvas.style.left = "0"
canvas.style.top = "0"
canvas.style.borderTopLeftRadius  = "3px"
canvas.style.borderTopRightRadius = "3px"
canvas.style.transition = canvas.style.webkitTransition = "top 0.3s ease-out"

controller.connect();




peer = controller.plugins.networking.peer;

window.location.hash = '';
peer.on('open', (id) ->
  console.log "got id #{id}";
);




leapChat = new LeapChat()

enhanceChatWindows = ->
  console.log "I am enhancing chat window"
  # get the Flyout Inner, but only if it has a Titlebar.titlebar.  These are the actual chats.
  leapChat.enhance $('.fbNubFlyout .fbNubFlyoutInner:not(.leap-facebook-chat) .fbNubFlyoutTitlebar.titlebar').parent()

setInterval(enhanceChatWindows, LeapChat.chatEnhanceFrequency)


# 1: Add element to page
# 2: show local hands
# 3: call button
# call persists until hang up, explicitly.
# when un-focus, stop streaming data
# customize PeerJS server for call initiation
# 4: show remote hands, rotated