import JSBridge
import NAPI
import NAPIC

extension JSError: ValueConvertible {
    public init(_ env: napi_env, from: napi_value) throws {
        fatalError("Not implemented")
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        let name = try self.name.napiValue(env)
        let message = try self.message.napiValue(env)
        let code = try self.code.map({ try $0.napiValue(env) })

        var status: napi_status!

        var result: napi_value!
        status = napi_create_error(env, code, message, &result)
        guard status == napi_ok else { throw NAPI.Error(status) }

        status = napi_set_named_property(env, result, "name", name)
        guard status == napi_ok else { throw NAPI.Error(status) }

        return result
    }
}
