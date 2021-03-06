// Generated by CoffeeScript 1.7.1
(function() {
  var enhanceChatWindows, leapChat, peer;

  window.controller = new Leap.Controller({
    background: true,
    checkVersion: false
  });

  controller.use('networking', {
    peer: new Peer({
      secure: true,
      key: 'ah7pg4vez7kz9f6r'
    })
  });

  controller.use('riggedHand', {
    scale: 1.5
  });

  controller.on('riggedHand.handFound', function(skinnedMesh) {
    console.log('hand found');
    return skinnedMesh.transparent = false;
  });

  window.riggedHand = controller.plugins.riggedHand;

  window.canvas = controller.plugins.riggedHand.renderer.domElement;

  window.canvasHeight = 120;

  canvas.style.width = "100%";

  canvas.style.height = "" + canvasHeight + "px";

  canvas.style.background = "rgba(0,0,0,0.8)";

  canvas.style.zIndex = "-1";

  canvas.style.position = "absolute";

  canvas.style.left = "0";

  canvas.style.top = "0";

  canvas.style.borderTopLeftRadius = "3px";

  canvas.style.borderTopRightRadius = "3px";

  canvas.style.transition = canvas.style.webkitTransition = "top 0.3s ease-out";

  controller.connect();

  peer = controller.plugins.networking.peer;

  window.location.hash = '';

  peer.on('open', function(id) {
    return console.log("got id " + id);
  });

  leapChat = new LeapChat();

  enhanceChatWindows = function() {
    console.log("I am enhancing chat window");
    return leapChat.enhance($('.fbNubFlyout .fbNubFlyoutInner:not(.leap-facebook-chat) .fbNubFlyoutTitlebar.titlebar').parent());
  };

  setInterval(enhanceChatWindows, LeapChat.chatEnhanceFrequency);

}).call(this);
