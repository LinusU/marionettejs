const assert = require('assert')
const http = require('http')

const Page = require('.')

function startServer () {
  const server = http.createServer((req, res) => {
    res.end('<!DOCTYPE html><html><body>Hello, World!</body></html>')
  })

  server.unref()

  return new Promise((resolve) => {
    server.listen(58234, () => resolve(`http://localhost:58234`))
  })
}

async function main () {
  const server = await startServer()
  const page = new Page()

  {
    await page.goto(server)
  }

  {
    const result = await page.evaluate('document.body.textContent')
    assert.strictEqual(result, 'Hello, World!')
  }

  {
    await assert.rejects(page.evaluate('window.foo.bar.baz'))
  }

  {
    const result = await page.evaluate('{ a: 1, b: [2, 3], c: null, d: { foo: "bar", baz: true } }')
    assert.deepStrictEqual(result, { a: 1, b: [2, 3], c: null, d: { foo: "bar", baz: true } })
  }
}

main().then(
  () => {
    console.log('ok')
  },
  (err) => {
    process.exitCode = 1
    console.error(err.stack)
  }
)
