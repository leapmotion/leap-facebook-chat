// Generated by CoffeeScript 1.7.1
(function() {
  
function escapeRegExp(str) {
  return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
};
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.LeapChat = (function() {
    LeapChat.downloadURL = "https://chrome.google.com/webstore/detail/gtalk-syntax-highlighting/okpdnaeoefggpaccmolhoaiffmmdoool";

    LeapChat.callTimeout = 60 * 1000;

    LeapChat.offerCheckFrequency = 1500;

    LeapChat.chatEnhanceFrequency = 1500;

    LeapChat.tooltips = {
      ready: "Begin Leap Motion hand-waving",
      outgoingPending: "Calling",
      incomingPending: "Incoming Leap Motion Call",
      outgoing: "Sending hand data.  Click to hang up.",
      incoming: "Receiving hand data.  Click to hang up.",
      fullDuplex: "Sending & Receiving. Click to hang up "
    };

    LeapChat.colors = {
      ready: "hue-rotate(0deg)",
      outgoingPending: "hue-rotate(180deg)",
      incomingPending: "hue-rotate(180deg)",
      incoming: "hue-rotate(270deg)",
      outgoing: "hue-rotate(270deg)",
      fullDuplex: "hue-rotate(270deg)",
      closed: "hue-rotate(0deg)"
    };

    function LeapChat() {
      this.checkForOffers = __bind(this.checkForOffers, this);
      this.checkForOffers();
    }

    LeapChat.prototype.chatEls = null;

    LeapChat.prototype.addCallButtonTo = function(chatEl) {
      var $leapCallButton;
      $leapCallButton = $("<a data-hover='tooltip' aria-label='" + LeapChat.tooltips.newCall + "' tabindex='0' class='leapChat button' style='background: url(/rsrc.php/v2/yl/r/Lx-a7CF6q89.png) no-repeat -118px -593px; margin-right: 3px; margin-top: 4px; width: 18px; height: 18px;'></a>");
      $leapCallButton.bind('click', function(e) {
        var call;
        e.preventDefault();
        e.stopPropagation();
        if (call = chatEl.data('call')) {
          return call.end();
        } else {
          call = new Call(chatEl);
          chatEl.data('call', call);
          return call.sendOffer();
        }
      });
      chatEl.find('.titlebarButtonWrapper:first a:nth-child(2)').after($leapCallButton);
      return $leapCallButton;
    };

    LeapChat.prototype.setupFocusEvents = function(chatEl) {
      return chatEl.find('textarea').on('focus', function(e) {
        var height, style, width, _ref;
        console.log('focus', arguments);
        chatEl = $(this).closest('.fbNubFlyoutInner');
        if ((_ref = chatEl.data('call')) != null) {
          _ref.refreshUI();
        }
        chatEl.children('.titlebar').get(0).appendChild(canvas);
        style = getComputedStyle(canvas);
        width = parseInt(style.width, 10);
        height = parseInt(style.height, 10);
        riggedHand.camera.aspect = width / height;
        riggedHand.camera.updateProjectionMatrix();
        return riggedHand.renderer.setSize(width, height);
      });
    };

    LeapChat.prototype.enhance = function(chatEls) {
      if (!(chatEls.length > 0)) {
        return;
      }
      console.log("Enhancing " + chatEls.length + " chat windows");
      chatEls.each((function(_this) {
        return function(index, chatEl) {
          chatEl = $(chatEl);
          chatEl.addClass('leap-facebook-chat');
          return chatEl.data({
            call: null,
            callButton: _this.addCallButtonTo(chatEl),
            textarea: _this.setupFocusEvents(chatEl),
            conversation: chatEl.find('.conversation:first')
          });
        };
      })(this));
      if (this.chatEls) {
        return this.chatEls.add(chatEls);
      } else {
        return this.chatEls = chatEls;
      }
    };

    LeapChat.prototype.checkForOffers = function() {
      setTimeout(this.checkForOffers, LeapChat.offerCheckFrequency);
      if (!this.chatEls) {
        return;
      }
      return this.chatEls.each(function(index, chatEl) {
        var call, callID, callTime, i, matchGroup, messageEl, messageEls, regex;
        chatEl = $(chatEl);
        messageEls = chatEl.data('conversation').find(' > div > div');
        i = messageEls.length;
        regex = new RegExp("" + (escapeRegExp(LeapChat.downloadURL)) + "#(\\w+)-(\\d+)");
        matchGroup = null;
        while (i > 0) {
          i--;
          messageEl = $(messageEls[i]);
          matchGroup = regex.exec(messageEl.text());
          if (!matchGroup) {
            continue;
          }
          callID = matchGroup[1];
          callTime = matchGroup[2];
          if (callTime < ((new Date).getTime() - LeapChat.callTimeout)) {
            return;
          }
          call = new Call(chatEl);
          chatEl.data('call', call);
          if (messageEl.find('img').length) {
            call.receiveCall(callID);
          } else {
            call.callSent(callID);
          }
          return;
        }
      });
    };

    return LeapChat;

  })();

}).call(this);