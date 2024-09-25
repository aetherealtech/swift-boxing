import Foundation
import Testing

@testable import Boxing

struct TestStruct: Equatable {
    var intMember: Int
    var stringMember: String
}

@Test func testReference() async throws {
    @MutableReference
    var mutableReference = TestStruct(intMember: 5, stringMember: "Hello")
    
    @Reference
    var reference: TestStruct
    
    _reference = _mutableReference
    
    #expect(mutableReference == TestStruct(intMember: 5, stringMember: "Hello"))
    #expect(reference == TestStruct(intMember: 5, stringMember: "Hello"))
    
    #expect(mutableReference.intMember == 5)
    #expect(reference.intMember == 5)
    
    #expect(mutableReference.stringMember == "Hello")
    #expect(reference.stringMember == "Hello")
    
    mutableReference.intMember = 8
    
    #expect(mutableReference == TestStruct(intMember: 8, stringMember: "Hello"))
    #expect(reference == TestStruct(intMember: 8, stringMember: "Hello"))
    
    #expect(mutableReference.intMember == 8)
    #expect(reference.intMember == 8)
    
    _mutableReference = .init(wrappedValue: .init(intMember: 4, stringMember: "HelloAgain"))
    
    #expect(mutableReference == TestStruct(intMember: 4, stringMember: "HelloAgain"))
    #expect(reference == TestStruct(intMember: 8, stringMember: "Hello"))
}

@objc final class TestObjcValue: NSObject {
    var intMember: Int
    var stringMember: String
    
    init(
        intMember: Int,
        stringMember: String
    ) {
        self.intMember = intMember
        self.stringMember = stringMember
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? TestObjcValue else {
            return false
        }
        
        return object.intMember == intMember &&
            object.stringMember == stringMember
    }
}

extension TestObjcValue: DeepCopyable {
    func copy() -> TestObjcValue {
        .init(
            intMember: intMember,
            stringMember: stringMember
        )
    }
}

@Test func testValue() async throws {
    var value = Value(TestObjcValue(intMember: 5, stringMember: "Hello"))
    var copy = value
        
    #expect(value == TestObjcValue(intMember: 5, stringMember: "Hello"))
    #expect(copy == TestObjcValue(intMember: 5, stringMember: "Hello"))
    
    #expect(value.intMember == 5)
    #expect(copy.intMember == 5)
    
    #expect(value.stringMember == "Hello")
    #expect(copy.stringMember == "Hello")
    
    value.intMember = 8
    
    #expect(value == TestObjcValue(intMember: 8, stringMember: "Hello"))
    #expect(copy == TestObjcValue(intMember: 5, stringMember: "Hello"))
    
    #expect(value.intMember == 8)
    #expect(copy.intMember == 5)
    
    copy.stringMember = "HelloAgain"
        
    #expect(value == TestObjcValue(intMember: 8, stringMember: "Hello"))
    #expect(copy == TestObjcValue(intMember: 5, stringMember: "HelloAgain"))
    
    value.value = .init(intMember: 10, stringMember: "HelloThrice")
    
    #expect(value == TestObjcValue(intMember: 10, stringMember: "HelloThrice"))
    #expect(copy == TestObjcValue(intMember: 5, stringMember: "HelloAgain"))
}
