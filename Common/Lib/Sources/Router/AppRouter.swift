//
//  AppRouter.swift
//  CommonLayer
//
//  Created by 최재혁 on 7/23/25.
//

import Foundation
import UIKit

public protocol Routable {
    func navigate(to route : AppRoute, from : Routable?, with data : [String: Any])
}


public final class AppRouter : Routable {
    public static let shared = AppRouter()
    
    private var factories : [AppRoute : () -> Routable] = [:]
    
    private init() { }
    
    public func register(route : AppRoute, factory : @escaping () -> Routable) {
        factories[route] = factory
    }
    
    public func navigate(to route: AppRoute, from: Routable?, with data: [String : Any]) {
        guard let router = factories[route]?() else { return }
        guard let navigateType = data["navigateType"] as? NavigateType else { return }
        
        // TODO: topview 찾고 -> UIWindow의 rootviewcon을 찾아서 -> Navigation이 될꺼고 -> 띄우는걸로
        // TODO: 모듈마다 모듈 내부 view 이동 router -> 해당 router는 approtuer 에서 관리
        // 여기서는 그냥 각 모듈을 present, push 하는 정도 역할만
        // 만약 스택을 비워야 한다면 해당 모듈에서 스택을 비우고 가는 걸로
        
//        switch navigateType {
//        case .push:
//            if let navigationController = from?.navigationController {
//                navigationController.pushViewController(viewController, animated: true)
//            }
//        case .present:
//            from?.present(viewController, animated: true)
//        case .fullscreen:
//            viewController.modalPresentationStyle = .fullScreen
//            from?.present(viewController, animated: true)
//        case .currentContext:
//            viewController.modalPresentationStyle = .currentContext
//            from?.present(viewController, animated: true)
//        case .overFullScreen:
//            viewController.modalPresentationStyle = .overFullScreen
//            from?.present(viewController, animated: true)
//        case .overCurrentContext:
//            viewController.modalPresentationStyle = .overCurrentContext
//            from?.present(viewController, animated: true)
//        case .custom:
//            if let transitioningDelegate = data["transitioningDelegate"] as? UIViewControllerTransitioningDelegate {
//                    viewController.modalPresentationStyle = .custom
//                    viewController.transitioningDelegate = transitioningDelegate
//                }
//                from?.present(viewController, animated: true)
//        }
        
    }
}
