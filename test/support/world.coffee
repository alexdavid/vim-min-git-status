Promise = require 'bluebird'
async = Promise.coroutine
childProcess = Promise.promisifyAll require 'child_process'
path = require 'path'
pty = require 'pty.js'
{TermWriter, TermBuffer} = require 'vt'


class World

  # Resolves when terminal doesn't output anything for a while
  waitForTerminal: async ->
    @terminal.on 'data', -> sawData = yes
    while sawData ? yes
      yield Promise.delay 50
      sawData = no
    return


  exec: async (cmd, {allowError} = {}) ->
    execPromise = childProcess.execAsync cmd, cwd: @tmpDir.path
    yield if allowError then execPromise.catch(->) else execPromise


  startVim: async ->
    @termBuffer = new TermBuffer 80, 24
    termWriter = new TermWriter @termBuffer
    @terminal = pty.spawn 'vim', ['-u', path.join(__dirname, '..', 'test-vim-rc.vim')],
      name: 'xterm-color'
      cols: 80
      rows: 24
      cwd: @tmpDir.path
      env: {}

    @terminal.on 'data', (data) ->
      termWriter.write data

    yield @waitForTerminal()


module.exports = ->
  @World = World
