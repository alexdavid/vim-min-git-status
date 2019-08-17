const { Given, When, Then } = require("cucumber")

Given(/^my terminal is (\d+) rows high$/, async function(rows) {
  await this.resize({rows})
})

When(/^I run :([^ ]+)(?: again)?/, async function(vimCommand) {
  this.terminal.write(`:${vimCommand}\n`)
  await this.waitForTerminal()
})

When(/^I type "([^"]+)" to .+$/, async function(key) {
  this.terminal.write(key)
  await this.waitForTerminal()
})

Then(/^I see$/, async function(block) {
  await this.waitForTerminal()
  if (this.termBuffer.toString().indexOf(block) === -1) {
    throw Error(`Terminal:\n${this.termBuffer.toString()}\n\nExpected:\n${block}`)
  }
})

Then(/^I don't see Gministatus$/, function() {
  if (this.termBuffer.toString().indexOf('.git/mini-status') !== -1) {
    throw Error(`Expected Gministatus to be closed but saw:\n${this.termBuffer.toString()}`)
  }
})

Then(/^Gministatus only takes up (\d+) lines$/, async function(expectedLines) {
  this.terminal.write(":echo 'LINES:' . winheight(0) . ';;'\n")
  await this.waitForTerminal()
  const [match, actualLines] = this.termBuffer.toString().match(/LINES:(\d+);/) || []
  if (!match) throw Error(`Expected to see LINES: but saw: ${this.termBuffer.toString()}`)
  if (parseInt(actualLines, 10) !== expectedLines) {
    throw Error(`Expected Gministatus to have ${expectedLines} but was ${actualLines}`)
  }
})
