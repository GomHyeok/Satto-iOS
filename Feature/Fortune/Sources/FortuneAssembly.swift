//
//  FortuneAssembly.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/15/25.
//

import DIInjector
import Foundation

public final class FortuneAssembly: Assembly {
    public func assemble(container: Container) {
        container.register(FortuneService.self) { _ in
            return FortuneService()
        }
    }
    
    public init(){ }
}
