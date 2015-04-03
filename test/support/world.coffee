childProcess = require 'child_process'
path = require 'path'
pty = require 'pty.js'
{TermWriter, TermBuffer} = require 'vt'
{TerminalWaiter} = require './terminal_waiter'


class World

  waitForTerminal: (done) =>
    new TerminalWaiter @terminal, done


  exec: (cmd, {allowError} = {}) => (done) =>
    childProcess.exec cmd, cwd: @path, (err) ->
      done unless allowError then err


  startVim: (done) =>
    @termBuffer = new TermBuffer 80, 24
    termWriter = new TermWriter @termBuffer
    @terminal = pty.spawn 'vim', ['-u', path.join(__dirname, '..', 'test-vim-rc.vim')],
      name: 'xterm-color'
      cols: 80
      rows: 24
      cwd: @path
      env: {}

    @terminal.on 'data', (data) ->
      termWriter.write data

    @waitForTerminal done


module.exports = ->
  @World = (done) ->
    done new World
