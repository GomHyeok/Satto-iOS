//
//  NavigateType.swift
//  CommonLayer
//
//  Created by 최재혁 on 7/23/25.
//

public enum NavigateType {
  case push  // NavigationController.pushViewController
  case present  // 기본 present (모달)
  case fullscreen  // modalPresentationStyle = .fullScreen
  case currentContext  // modalPresentationStyle = .currentContext
  case overFullScreen  // modalPresentationStyle = .overFullScreen
  case overCurrentContext  // modalPresentationStyle = .overCurrentContext
  case custom  // custom 전환 (transitioningDelegate 필요)
}
