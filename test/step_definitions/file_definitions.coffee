async = require 'async'


module.exports = ->

  @Given /^I have an untracked file "([^"]+)"$/, (fileName, done) ->
    async.series [
      @exec "echo 'Initial content for #{fileName}' > #{fileName}"
    ], done


  @When /^I delete "([^"]+)"$/, (fileName, done) ->
    async.series [
      @exec "rm #{fileName}"
    ], done


  @When /^I modify "([^"]+)"$/, (fileName, done) ->
    async.series [
      @exec "echo 'modify #{fileName}' >> #{fileName}"
    ], done


  @When /^I rename "([^"]+)" to "([^"]+)"$/, (fileName, newName, done) ->
    async.series [
      @exec "mv #{fileName} #{newName}"
    ], done
