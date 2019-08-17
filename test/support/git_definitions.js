const { Given, When } = require("cucumber")

Given(/^I commit changes to "([^"]+)" in "([^"]+)" branch$/, async function(fileName, branchName) {
  await this.execGit(["checkout", branchName])
  await this.appendFile(fileName, `modify ${fileName} in ${branchName}`)
  await this.execGit(["add", fileName])
  await this.execGit(["commit", "-m", `Modify ${fileName}`])
  await this.execGit(["checkout", "-"])
})

Given(/^I delete "([^"]+)" in "([^"]+)" branch$/, async function(fileName, branchName) {
  await this.execGit(["checkout", branchName])
  await this.execGit(["rm", fileName])
  await this.execGit(["commit", "-m", `Remove ${fileName}`])
  await this.execGit(["checkout", "-"])
})

Given(/^I have a committed file "([^"]+)"$/, async function(fileName) {
  await this.writeFile(fileName, `Initial content for ${fileName}`)
  await this.execGit(["add", fileName])
  await this.execGit(["commit", "-m", `Add ${fileName}`])
})

Given(/^I have a "([^"]+)" branch$/, async function(branchName) {
  await this.execGit(["branch", branchName])
})

When(/^I add "([^"]+)" to the index$/, async function(fileName) {
  await this.execGit(["add", fileName])
})

When(/^I merge "([^"]+)" into "([^"]+)"$/, async function(fromBranch, toBranch) {
  await this.execGit(["checkout", toBranch])
  await this.execGit(["merge", fromBranch], { allowError: true })
})

When(/^I remove "([^"]+)" from the index$/, async function(fileName) {
  await this.execGit(["rm", fileName])
})
