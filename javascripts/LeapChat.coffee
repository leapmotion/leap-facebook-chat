
`
function escapeRegExp(str) {
  return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
}`



class window.LeapChat

  # this should be updated with the actual webstore link
  @downloadURL = "https://chrome.google.com/webstore/detail/gtalk-syntax-highlighting/okpdnaeoefggpaccmolhoaiffmmdoool"

  # 60 second timeout on calls. Enough time to download the extension? #needsUX
  @callTimeout = 60 * 1000

  @offerCheckFrequency  = 1500

  @chatEnhanceFrequency = 1500

  @tooltips = {
    ready: "Begin Leap Motion hand-waving"
    outgoingPending: "Calling" # click to hang up
    incomingPending: "Incoming Leap Motion Call" # click to hang up
    outgoing: "Sending hand data.  Click to hang up."
    incoming: "Receiving hand data.  Click to hang up."
    fullDuplex: "Sending & Receiving. Click to hang up "
  }

  @colors = {
    ready: "hue-rotate(0deg)"
    outgoingPending: "hue-rotate(180deg)"
    incomingPending: "hue-rotate(180deg)"
    incoming: "hue-rotate(270deg)" #?
    outgoing: "hue-rotate(270deg)"
    fullDuplex: "hue-rotate(270deg)"
    closed: "hue-rotate(0deg)" #?
  }

  constructor: ->
    @checkForOffers()

  chatEls: null

  addCallButtonTo: (chatEl)->

    # add call button
    # this background url could change out from under us.
    $leapCallButton = $("<a data-hover='tooltip' aria-label='#{LeapChat.tooltips.newCall}' tabindex='0' class='leapChat button' style='background: url(/rsrc.php/v2/yl/r/Lx-a7CF6q89.png) no-repeat -118px -593px; margin-right: 3px; margin-top: 4px; width: 18px; height: 18px;'></a>")

    $leapCallButton.bind 'click', (e)->
      e.preventDefault();
      e.stopPropagation();

      if call = chatEl.data('call')
        call.end()
      else
        call = new Call(chatEl)
        chatEl.data('call', call)
        call.sendOffer()

    chatEl.find('.titlebarButtonWrapper:first a:nth-child(2)').after($leapCallButton)
    return $leapCallButton


  setupFocusEvents: (chatEl)->
    chatEl.find('textarea').on 'focus', (e)->
      console.log 'focus', arguments
      chatEl = $(this).closest('.fbNubFlyoutInner')

      # reset the height on shared canvas element.
      chatEl.data('call')?.refreshUI()

      chatEl.children('.titlebar').get(0).appendChild(canvas)

      # correct canvas aspect ratio:
      style = getComputedStyle(canvas)
      width = parseInt(style.width, 10)
      height= parseInt(style.height, 10)

      riggedHand.camera.aspect = width / height;
      riggedHand.camera.updateProjectionMatrix();
      riggedHand.renderer.setSize(width, height);


  # takes in a chat element with titlebar and textarea
  enhance: (chatEls)->
    return unless chatEls.length > 0
    console.log "Enhancing #{chatEls.length} chat windows"


    chatEls.each (index, chatEl) =>
      chatEl = $(chatEl)
      chatEl.addClass('leap-facebook-chat')

      # this loops, rite?
      chatEl.data({
        call: null
        callButton: @addCallButtonTo(chatEl)
        textarea: @setupFocusEvents(chatEl)
        conversation: chatEl.find('.conversation:first')
      })

    if @chatEls
      @chatEls.add(chatEls)
    else
      @chatEls = chatEls

  # how do we handle a chat being closed?
  # don't want to handle an old or out-dated offer
  checkForOffers: =>
    setTimeout(@checkForOffers, LeapChat.offerCheckFrequency)

    return unless @chatEls

    @chatEls.each (index, chatEl) ->
      chatEl = $(chatEl)

      # we only have a really shitty way to look for incoming messages:
      # any second-level child div of the .conversation which doesn't have an img inside of it.
      # img would either be the other guy's avatar, or a picture-chat which doesn't matter anyway.

      messageEls = chatEl.data('conversation').find(' > div > div')
      i = messageEls.length
      regex = new RegExp("#{ escapeRegExp(LeapChat.downloadURL) }#(\\w+)-(\\d+)")
      matchGroup = null

      # loop from the most recent chats first
      while i > 0
        i--
        messageEl = $(messageEls[i])
        matchGroup = regex.exec( messageEl.text() )

        continue unless matchGroup

        callID = matchGroup[1]
        callTime = matchGroup[2]


        if callTime < ( (new Date).getTime() - LeapChat.callTimeout)
#          console.log "call to old (#{((new Date).getTime() - callTime ) / 1000 }s), aborting"
          return

        call = new Call(chatEl)
        chatEl.data('call', call)

        if messageEl.find('img').length # incoming
          call.receiveCall callID
        else
          call.callSent callID

        return