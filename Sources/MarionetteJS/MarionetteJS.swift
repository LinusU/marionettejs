import AppKit
import NAPI
import Foundation
import Marionette
import PromiseKit

class AppDelegate: NSObject, NSApplicationDelegate {
  let window = NSWindow(contentRect: NSMakeRect(20, 20, 1024, 768), styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: false, screen: nil)

  func applicationDidFinishLaunching(_ notification: Notification) {
    window.orderBack(nil)
  }
}

var globalDelegate: AppDelegate!

func setup() {
  globalDelegate = AppDelegate()
  NSApplication.shared.delegate = globalDelegate
  NSApplication.shared.activate(ignoringOtherApps: true)
  NSApplication.shared.finishLaunching()
}

func processEvents() {
  while let event = NSApplication.shared.nextEvent(matching: .any, until: .distantPast, inMode: .default, dequeue: true) {
    NSApplication.shared.sendEvent(event)
  }
}

class MarionetteJS: Marionette {
  override init() {
    super.init()
    self.webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
    globalDelegate.window.contentView!.addSubview(self.webView)
  }

  deinit {
    self.webView.removeFromSuperview()
  }
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
    .function("setup", setup),
    .function("processEvents", processEvents),

    .class("Page", MarionetteJS.init, [
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
