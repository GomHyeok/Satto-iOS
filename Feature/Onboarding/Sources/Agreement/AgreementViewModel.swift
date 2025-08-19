//
//  AgreementViewModel.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/19/25.
//

import Combine
import SafariServices

final class AgreementViewModel {
  
  enum Input {
    case acceptTermTapped
    case acceptInfoProvisionTapped
  }
  
  struct Output {
    let presentSafariViewController: PassthroughSubject<SFSafariViewController, Never> = .init()
  }
  
  let output: Output = .init()
  
  func send(input : Input) {
    switch input {
    case .acceptTermTapped:
      let url = NSURL(string: NotionLinke.terms.rawValue)
      let termSafariView : SFSafariViewController = SFSafariViewController(url: url! as URL)
      output.presentSafariViewController.send(termSafariView)
    case .acceptInfoProvisionTapped:
      let url = NSURL(string: NotionLinke.infoProvision.rawValue)
      let infoProvisionSafariView : SFSafariViewController = SFSafariViewController(url: url! as URL)
      output.presentSafariViewController.send(infoProvisionSafariView)
    }
  }
}
