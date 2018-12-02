module.exports = ->

  @Given /^I commit changes to "([^"]+)" in "([^"]+)" branch$/, (fileName, branchName) ->
    yield @execGit ["checkout", branchName]
    yield @appendFile fileName, "modify #{fileName} in #{branchName}"
    yield @execGit ["add", fileName]
    yield @execGit ["commit", "-m", "Modify #{fileName}"]
    yield @execGit ["checkout", "-"]


  @Given /^I delete "([^"]+)" in "([^"]+)" branch$/, (fileName, branchName) ->
    yield @execGit ["checkout", branchName]
    yield @execGit ["rm", fileName]
    yield @execGit ["commit", "-m", "Remove #{fileName}"]
    yield @execGit ["checkout", "-"]


  @Given /^I have a committed file "([^"]+)"$/, (fileName) ->
    yield @writeFile fileName, "Initial content for #{fileName}"
    yield @execGit ["add", fileName]
    yield @execGit ["commit", "-m", "Add #{fileName}"]


  @Given /^I have a "([^"]+)" branch$/, (branchName) ->
    yield @execGit ["branch", branchName]


  @When /^I add "([^"]+)" to the index$/, (fileName) ->
    yield @execGit ["add", fileName]


  @When /^I merge "([^"]+)" into "([^"]+)"$/, (fromBranch, toBranch) ->
    yield @execGit ["checkout", toBranch]
    yield @execGit ["merge", fromBranch], allowError: yes


  @When /^I remove "([^"]+)" from the index$/, (fileName) ->
    yield @execGit ["rm", fileName]
