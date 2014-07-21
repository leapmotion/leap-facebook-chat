console.log "I am chrome extension"

class LeapChat

  enhance: (jqElem)->
    canvasHeight = 120
    jqElem.addClass('leap-facebook-chat')
    jqElem.append("<div style='width: 100%; height: #{canvasHeight}px; background: black; z-index: 100; position: absolute; left: 0; top: -#{canvasHeight}px;'></div>")


leapChat = new LeapChat()

enhanceChatWindows = ->
  console.log "I am enhancing chat window"
  leapChat.enhance $('.fbNubFlyout .fbNubFlyoutTitlebar.titlebar:not(.leap-facebook-chat)')

setInterval(enhanceChatWindows, 1500)


# 1: Add element to page
# 2: show local hands
# 3: call button
# call persists until hang up, explicitly.
# when un-focus, stop streaming data
# 4: show remote hands, rotated