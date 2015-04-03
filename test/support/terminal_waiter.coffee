# Executes a callback when a terminal doesn't output anything for a while
class TerminalWaiter

  # Time to wait after recieving output before calling callback
  TIMEOUT = 50


  constructor: (terminal, @callback) ->
    @timeout = setTimeout @run, TIMEOUT
    terminal.on 'data', @restartTimer


  restartTimer: =>
    clearTimeout @timeout
    @timeout = setTimeout @run, TIMEOUT


  run: =>
    return if @hasRun
    @callback()
    @hasRun = yes


module.exports = {TerminalWaiter}
