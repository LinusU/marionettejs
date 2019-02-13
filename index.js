const native = require('./.build/release/MarionetteJS.node')

function tick () {
  native.runLoop()
  setTimeout(tick, 0)
}

// FIXME: Find a better way to do this
tick()

module.exports = native.Page
