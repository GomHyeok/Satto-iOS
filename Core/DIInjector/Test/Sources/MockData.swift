//
//  MockData.swift
//  CoreLayer
//
//  Created by 최재혁 on 7/21/25.
//

import Swinject

public class MockClass {
    func mockFunc() -> Bool {
        print("MockClass Registered")
        return true
    }
}

public struct MockAssembly : Assembly {
    public func assemble(container: Container) {
        container.register(MockClass.self) { _ in
            return MockClass()
        }
    }
}
