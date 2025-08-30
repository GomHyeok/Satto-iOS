//
//  NavigateType.swift
//  CommonLayer
//
//  Created by 최재혁 on 7/23/25.
//

public enum NavigateType {
  case push(hidesBottomBarWhenPushed: Bool = false)  // NavigationController.pushViewController
  case present  // 기본 present (모달)
  case fullscreen  // modalPresentationStyle = .fullScreen
  case currentContext  // modalPresentationStyle = .currentContext
  case overFullScreen  // modalPresentationStyle = .overFullScreen
  case overCurrentContext  // modalPresentationStyle = .overCurrentContext
  case custom  // custom 전환 (transitioningDelegate 필요)
  case clear  //해당 router 관련 view 전부 지움
  case pop
}
