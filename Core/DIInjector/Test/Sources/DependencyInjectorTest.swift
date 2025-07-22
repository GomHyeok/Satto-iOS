//
//  DependencyInjectorTest.swift
//  DITest
//
//  Created by 최재혁 on 7/21/25.
//

import Testing
import Swinject
import DIInjector

struct DependencyInjectorTest {
    
    init() async throws {
        DependencyInjector.shared.assemble([
        MockAssembly()
    ])}
    
    @Test func dependencyTest() {
        @Injected var mockClass : MockClass
        #expect(mockClass.mockFunc())
    }
}
