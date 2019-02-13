import NAPI
import NAPIC
import Foundation

extension URL: NAPI.ValueConvertible {
  public init(_ env: napi_env, from: napi_value) throws {
    self.init(string: try String(env, from: from))!
  }

  public func napiValue(_ env: napi_env) throws -> napi_value {
    return try self.absoluteString.napiValue(env)
  }
}
