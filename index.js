const native = require('./.build/release/MarionetteJS.node')

native.setup()
setInterval(() => native.processEvents(), 20).unref()

module.exports = native.Page
