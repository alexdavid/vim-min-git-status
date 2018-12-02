module.exports = ->

  @Given /^I have an untracked file "([^"]+)"$/, (fileName) ->
    yield @writeFile fileName, "Initial content for #{fileName}"


  @Given /^I have (\d+) untracked files$/, (numFiles) ->
    for i in [0..numFiles]
      yield @writeFile "untracked_file_#{i}", "untracked file"


  @When /^I delete "([^"]+)"$/, (fileName) ->
    yield @unlinkFile fileName


  @When /^I modify "([^"]+)"$/, (fileName) ->
    yield @appendFile fileName, "modify #{fileName}"


  @When /^I rename "([^"]+)" to "([^"]+)"$/, (fileName, newName) ->
    yield @moveFile fileName, newName
