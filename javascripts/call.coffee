# one call
# attached to the DOM element the $.data
class window.Call

  # do we need a closed state? We don't want a rapid call+hang-up to end up calling again.
  # but currently this prevents two calls w/o reloading the page
  @states = ['ready', 'outgoingPending', 'incomingPending', 'outgoing', 'incoming', 'fullDuplex', 'closed']

  constructor: (@chatEl)->
    @state = 'ready'

  active: ->
    ['ready', 'closed'].indexOf(@state) == -1

  # poor-man's auto-applied templating:
  refreshUI: ->
    @chatEl.data('callButton').css('-webkit-filter', LeapChat.colors[@state]).attr("aria-label", LeapChat.tooltips[@state])
    height = if @active() then canvasHeight else 0

    $(canvas).css(top: "-#{height}px")

  offerURL: ->
    callID = "abcde"
    timestamp = (new Date).getTime()
    "#{LeapChat.downloadURL}##{callID}-#{timestamp}"

  # sends a message with unique ID for initiating a call
  sendOffer: ->
    input = @chatEl.data('textarea')
    input.focus()
    input.val(input.val() + "Trying to call you with Leap Motion chat: #{@offerURL()}")

  # this will stop sending data, but shouldn't actually prevent the reception of data (just like chat)
  end: ->
    @state = 'closed'
    @refreshUI()


  receiveCall: (callId)->
    return unless @state == 'ready'
    @state = 'incomingPending' # briefly while connection is being established. requires no user interaction.
    console.log "receive call: #{callId}"
    @refreshUI()

  callSent: (callId)->
    return unless @state == 'ready'
    @state = 'outgoingPending'

    console.log('call outgoing')

    @refreshUI()

  # an outgoing call has been picked up by the remote peer
  connectionOpen: (callId)->
    @state = 'outgoing'
    console.log "connectionOpen: #{callId}"
    @refreshUI()
