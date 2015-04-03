async = require 'async'

module.exports = ->

  @Given /^I commit changes to "([^"]+)" in "([^"]+)" branch$/, (fileName, branchName, done) ->
    async.series [
      @exec "git checkout #{branchName}"
      @exec "echo 'modify #{fileName} in #{branchName}' >> #{fileName}"
      @exec "git add #{fileName}"
      @exec "git commit -m 'Modify #{fileName}'"
      @exec "git checkout -"
    ], done


  @Given /^I have a committed file "([^"]+)"$/, (fileName, done) ->
    async.series [
      @exec "echo 'Initial content for #{fileName}' > #{fileName}"
      @exec "git add #{fileName}"
      @exec "git commit -m 'Add #{fileName}'"
    ], done


  @Given /^I have a "([^"]+)" branch$/, (branchName, done) ->
    async.series [
      @exec "git branch #{branchName}"
    ], done


  @When /^I add "([^"]+)" to the index$/, (fileName, done) ->
    async.series [
      @exec "git add #{fileName}"
    ], done


  @When /^I merge "([^"]+)" into "([^"]+)"$/, (fromBranch, toBranch, done) ->
    async.series [
      @exec "git checkout #{toBranch}"
      @exec "git merge #{fromBranch}", allowError: yes
    ], done


  @When /^I remove "([^"]+)" from the index$/, (fileName, done) ->
    async.series [
      @exec "git rm #{fileName}"
    ], done
