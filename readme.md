# MarionetteJS

Node.js bindings for [Marionette](https://github.com/LinusU/Marionette), a high-level API to control a WKWebView.

## Installation

```sh
npm install --save marionettejs
```

## Usage

```js
const Page = require('marionettejs')

const page = new Page()

// Go to google
await page.goto('https://www.google.com/')

// Type in "LinusU Marionette"
await page.type(`input[name='q']`, 'LinusU Marionette')

// Click the search button, and wait for navigation
await Promise.all([page.waitForNavigation(), page.click(`input[type='submit']`)])
```
