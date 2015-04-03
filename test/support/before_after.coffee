async = require 'async'
tmp = require 'tmp'


module.exports = ->

  @Before (done) ->
    async.series [
      (done) => tmp.dir (err, @path) => done err
      @exec 'git init'
      @startVim
    ], done


  @After (done) ->
    @terminal.destroy()
    done()
