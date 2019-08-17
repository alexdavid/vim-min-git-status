const { When } = require("cucumber")
const { delay } = require("bluebird")

When(/^I wait a second$/, async function() {
  await delay(1000)
})
