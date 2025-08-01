//
//  CoreLayerAssembly.swift
//  Satto
//
//  Created by 최재혁 on 7/23/25.
//

import Foundation

import DIInjector
import Lib

public class CoreLayerAssembly : Assembly {
    public func assemble(container: Container) {
        container.register(AppRouter.self) { _ in
            return AppRouter.shared
        }
    }
}
