public protocol DeepCopyable: AnyObject {
    func copy() -> Self
}

// A property wrapper would be nice, but that would make member access go directly to the underlying value which, as a reference type, would allow mutation.  The mutations wouldn't break the class, because they would be mutations on the `copy` returned by the `wrappedValue`, rather they will be effectively no-ops because the mutated value will be a temporary that is immediately discarded.  It will cause confusion to people using this when it appears their mutations aren't doing anything (basically the same problem that non-readonly structs in C# have) until they figure out they need to access the members through the wrapper itself.  If working with the value directly is mostly unhelpful and confusing, then we might as well force working with the wrapper but *not* making it a property wrapper.
@dynamicMemberLookup
public struct Value<T: DeepCopyable> {
    public var value: T {
        _read { yield _value.copy() }
        set { _value = newValue.copy() }
    }
    
    public init(_ value: T) {
        _value = value.copy()
    }

    public subscript<Member>(dynamicMember keyPath: KeyPath<T, Member>) -> Member {
        _read { yield _value[keyPath: keyPath] }
    }
    
    public subscript<Member>(dynamicMember keyPath: WritableKeyPath<T, Member>) -> Member {
        _read { yield _value[keyPath: keyPath] }
        _modify {
            if !isKnownUniquelyReferenced(&_value) {
                _value = _value.copy()
            }
            
            yield &_value[keyPath: keyPath]
        }
    }
    
    private var _value: T
}

extension Value: Equatable where T: Equatable {
    public static func == (lhs: Self, rhs: T) -> Bool {
        lhs._value == rhs
    }
    
    public static func == (lhs: T, rhs: Self) -> Bool {
        lhs == rhs._value
    }
}

extension Value: Hashable where T: Hashable {}

import Foundation

extension NSCopying {
    public func copy() -> Self {
        copy(with: nil) as! Self
    }
}
