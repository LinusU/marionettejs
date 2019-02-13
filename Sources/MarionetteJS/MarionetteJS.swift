import NAPI
import Foundation
import Marionette
import PromiseKit

func runLoop() {
  CFRunLoopRunInMode(.defaultMode, 0.02, false)
}

func pageClick(this: Marionette, selector: String) -> Promise<Void> {
  return this.click(selector)
}

func pageGoto(this: Marionette, url: URL) -> Promise<Void> {
  return this.goto(url)
}

func pageEvaluate(this: Marionette, code: String) -> Promise<NAPI.Value> {
  return this.evaluate(code)
}

func pageSetContent(this: Marionette, html: String) -> Promise<Void> {
  return this.setContent(html)
}

func pageType(this: Marionette, selector: String, text: String) -> Promise<Void> {
  return this.type(selector, text)
}

func pageReload(this: Marionette) -> Promise<Void> {
  return this.reload()
}

func pageWaitForFunction(this: Marionette, fn: String) -> Promise<Void> {
  return this.waitForFunction(fn)
}

func pageWaitForNavigation(this: Marionette) -> Promise<Void> {
  return this.waitForNavigation()
}

func pageWaitForSelector(this: Marionette, selector: String) -> Promise<Void> {
  return this.waitForSelector(selector)
}

@_cdecl("_init_marionettejs")
func initMarionetteJS(env: OpaquePointer, exports: OpaquePointer) -> OpaquePointer? {
  return NAPI.initModule(env, exports, [
    .function("runLoop", runLoop),

    .class("Page", Marionette.init, [
      .method("click", pageClick),
      .method("goto", pageGoto),
      .method("evaluate", pageEvaluate),
      .method("setContent", pageSetContent),
      .method("type", pageType),
      .method("reload", pageReload),
      .method("waitForFunction", pageWaitForFunction),
      .method("waitForNavigation", pageWaitForNavigation),
      .method("waitForSelector", pageWaitForSelector),
    ]),
  ])
}
