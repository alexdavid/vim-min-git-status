const tmp = require("tmp-promise")
const { Before, After } = require("cucumber")

Before(async function() {
  this.tmpDir = await tmp.dir({unsafeCleanup: true})
  await this.execGit(['init'])
  await this.startVim()
})

After(async function() {
  this.terminal.destroy()
  this.tmpDir.cleanup()
})
