module.exports = ->

  @When /^I run :([^ ]+)(?: again)?/, (vimCommand) ->
    @terminal.write ":#{vimCommand}\n"
    yield @waitForTerminal()


  @When /^I type "([^"]+)" to .+$/, (key) ->
    @terminal.write key
    yield @waitForTerminal()


  @Then /^I see$/, (block) ->
    block += "\n~"
    if @termBuffer.toString().indexOf(block) is -1
      throw Error "Terminal:\n#{@termBuffer.toString()}\n\nExpected:\n#{block}"


  @Then /^I don't see Gministatus$/, ->
    if @termBuffer.toString().indexOf('.git/mini-status') isnt -1
      throw Error "Expected Gministatus to be closed but saw:\n#{@termBuffer.toString()}"
