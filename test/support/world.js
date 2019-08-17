const Promise = require("bluebird")
const childProcess = Promise.promisifyAll(require("child_process"))
const fs = Promise.promisifyAll(require("fs"))
const path = require("path")
const pty = require("node-pty")
const { TermWriter, TermBuffer } = require("vt")
const { setWorldConstructor } = require("cucumber")

class World {
  constructor() {
    this.cols = 80
    this.rows = 24
  }

  async appendFile(fileName, content) {
    await fs.appendFileAsync(path.join(this.tmpDir.path, fileName), `${content}\n`)
  }

  async writeFile(fileName, content) {
    await fs.writeFileAsync(path.join(this.tmpDir.path, fileName), `${content}\n`)
  }

  async moveFile(fileName, newName) {
    await fs.renameAsync(
      path.join(this.tmpDir.path, fileName),
      path.join(this.tmpDir.path, newName),
    )
  }

  async unlinkFile(fileName) {
    await fs.unlinkAsync(path.join(this.tmpDir.path, fileName))
  }

  // Resolves when terminal doesn't output anything for a while
  async waitForTerminal() {
    let sawData = false
    this.terminal.on("data", () => sawData = true)
    await Promise.delay(50)
    while (sawData === true) {
      await Promise.delay(50)
      sawData = false
    }
  }

  async execGit(args, {allowError} = {}) {
    const cwd = this.tmpDir.path
    try {
      await childProcess.execFileAsync("/usr/bin/git", args, {cwd})
    } catch (err) {
      if (!allowError) throw err
    }
  }

  async resize({rows, cols}) {
    if (cols) this.cols = parseInt(cols)
    if (rows) this.rows = parseInt(rows)
    this.termBuffer.resize(this.cols, this.rows)
    this.terminal.resize(this.cols, this.rows)
    await this.waitForTerminal()
  }

  async startVim() {
    this.termBuffer = new TermBuffer(this.cols, this.rows)
    const termWriter = new TermWriter(this.termBuffer)
    this.terminal = pty.spawn("vim", ["-u", path.join(__dirname, "..", "test-vim-rc.vim")], {
      name: "xterm-color",
      cols: this.cols,
      rows: this.rows,
      cwd: this.tmpDir.path,
      env: {},
    })

    this.terminal.on("data", data => termWriter.write(data))
    await this.waitForTerminal()
  }
}

setWorldConstructor(World)
