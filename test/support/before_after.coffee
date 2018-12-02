tmp = require 'tmp-promise'


module.exports = ->

  @Before ->
    @tmpDir = yield tmp.dir unsafeCleanup: yes
    yield @execGit ['init']
    yield @startVim()


  @After ->
    @terminal.destroy()
    @tmpDir.cleanup()
