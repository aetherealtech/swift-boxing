@propertyWrapper
public class Reference<T: ~Copyable> {
    public var wrappedValue: T {
        _read { yield _value }
    }
    
    fileprivate init(_value: consuming T) {
        self._value = _value
    }
    
    fileprivate var _value: T
}

@propertyWrapper
public final class MutableReference<T: ~Copyable>: Reference<T> {
    public override var wrappedValue: T {
        _read { yield _value }
        _modify { yield &_value }
    }

    public init(wrappedValue: consuming T) {
        super.init(_value: wrappedValue)
    }
}
