import NAPI
import NAPIC
import PromiseKit

fileprivate func createError(_ env: napi_env, message: String) throws -> napi_value {
    var result: napi_value!

    let status = napi_create_error(env, nil, try? message.napiValue(env), &result)
    guard status == napi_ok else { throw NAPI.Error(status) }

    return result
}

fileprivate extension napi_deferred {
    func resolve(_ env: napi_env, _ resolution: napi_value) throws {
        let status = napi_resolve_deferred(env, self, resolution)
        guard status == napi_ok else { throw NAPI.Error(status) }
    }

    func reject(_ env: napi_env, _ rejection: napi_value) throws {
        let status = napi_reject_deferred(env, self, rejection)
        guard status == napi_ok else { throw NAPI.Error(status) }
    }
}

public extension PropertyDescriptor {
    public static func method<This: AnyObject>(_ name: String, _ callback: @escaping (This) throws -> Promise<Void>, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return PropertyDescriptor.method(name, { (this: This) in return try callback(this).map({ NAPI.Value.undefined }) }, attributes: attributes)
    }

    public static func method<This: AnyObject, A: ValueConvertible>(_ name: String, _ callback: @escaping (This, A) throws -> Promise<Void>, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return PropertyDescriptor.method(name, { (this: This, a: A) in return try callback(this, a).map({ NAPI.Value.undefined }) }, attributes: attributes)
    }

    public static func method<This: AnyObject, A: ValueConvertible, B: ValueConvertible>(_ name: String, _ callback: @escaping (This, A, B) throws -> Promise<Void>, attributes: napi_property_attributes = napi_default) -> PropertyDescriptor {
        return PropertyDescriptor.method(name, { (this: This, a: A, b: B) in return try callback(this, a, b).map({ NAPI.Value.undefined }) }, attributes: attributes)
    }
}

extension Promise where T == Void {
    func napiValue(_ env: napi_env) throws -> napi_value {
        return try self.map({ NAPI.Value.undefined }).napiValue(env)
    }
}

extension Promise: NAPI.ValueConvertible where T: NAPI.ValueConvertible {
    public convenience init(_ env: napi_env, from: napi_value) throws {
        fatalError("Not implemented")
    }

    public func napiValue(_ env: napi_env) throws -> napi_value {
        try NAPI.RunLoop.ref(env)

        var deferred: napi_deferred!
        var promise: napi_value!

        let status = napi_create_promise(env, &deferred, &promise)
        guard status == napi_ok else { throw NAPI.Error(status) }

        self.done {
            try deferred.resolve(env, $0.napiValue(env))
        }.catch {
            if let value = $0 as? ValueConvertible {
                try! deferred.reject(env, value.napiValue(env))
            } else {
                try! deferred.reject(env, createError(env, message: $0.localizedDescription))
            }
        }.finally {
            NAPI.RunLoop.unref()
        }

        return promise
    }
}
