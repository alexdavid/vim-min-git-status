module.exports = ->

  @When /^I run :([^ ]+)(?: again)?/, (vimCommand, done) ->
    @terminal.write ":#{vimCommand}\n"
    @waitForTerminal done


  @When /^I type "([^"]+)" to .+$/, (key, done) ->
    @terminal.write key
    @waitForTerminal done


  @Then /^I see$/, (block, done) ->
    block += "\n~"
    if @termBuffer.toString().indexOf(block) is -1
      done Error "Terminal:\n#{@termBuffer.toString()}\n\nExpected:\n#{block}"
    else
      done()
