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


  @Then /^I don't see Gministatus$/, (done) ->
    if @termBuffer.toString().indexOf('.git/mini-status') isnt -1
      done Error "Expected Gministatus to be closed but saw:\n#{@termBuffer.toString()}"
    else
      done()
