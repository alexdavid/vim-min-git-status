module.exports = ->

  @Given /^I have an untracked file "([^"]+)"$/, (fileName) ->
    yield @exec "echo 'Initial content for #{fileName}' > #{fileName}"


  @When /^I delete "([^"]+)"$/, (fileName) ->
    yield @exec "rm #{fileName}"


  @When /^I modify "([^"]+)"$/, (fileName) ->
    yield @exec "echo 'modify #{fileName}' >> #{fileName}"


  @When /^I rename "([^"]+)" to "([^"]+)"$/, (fileName, newName) ->
    yield @exec "mv #{fileName} #{newName}"
