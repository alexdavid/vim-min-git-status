const { Given, When } = require("cucumber")

Given(/^I have an untracked file "([^"]+)"$/, async function(fileName) {
  await this.writeFile(fileName, `Initial content for ${fileName}`)
})

Given(/^I have (\d+) untracked files$/, async function(numFiles) {
  for (let i = 0; i < numFiles; i++) {
    await this.writeFile(`untracked_file_${i}`, "untracked file")
  }
})

When(/^I delete "([^"]+)"$/, async function(fileName) {
  await this.unlinkFile(fileName)
})

When(/^I modify "([^"]+)"$/, async function(fileName) {
  await this.appendFile(fileName, `modify ${fileName}`)
})

When(/^I rename "([^"]+)" to "([^"]+)"$/, async function(fileName, newName) {
  await this.moveFile(fileName, newName)
})
