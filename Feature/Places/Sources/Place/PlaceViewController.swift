//
//  PlaceViewController.swift
//  FeatureLayer
//
//  Created by 최재혁 on 2/18/26.
//

import Foundation
import UIKit
import Base
import DesignSystem

public final class PlaceViewController: BaseViewController {
  enum Constant {
    static let firstButtonTitle = "이번 주 당첨"
    static let secondButtonTitle = "명당 리스트"
  }
  
  private let viewModel: PlaceViewModel
  
  private var currentVC: BaseViewController?
  
  private lazy var segmentedControl = SegmentedControl().then {
    $0.update(firstTitle: Constant.firstButtonTitle, secondTitle: Constant.secondButtonTitle, style: .gray)
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
    $0.delegate = self
  }
  
  private lazy var containerView: UIView = .init()
  
  public init(viewModel: PlaceViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
    viewModel.send(input: .viewDidLoad)
  }
}

extension PlaceViewController {
  private func setupUI() {
    view.backgroundColor = .white
    
    view.addSubview(segmentedControl)
    view.addSubview(containerView)
    
    segmentedControl.snp.makeConstraints{ make in
      make.top.equalToSuperview().offset(12)
      make.leading.trailing.equalToSuperview().inset(24)
      make.height.equalTo(40)
    }
    
    containerView.snp.makeConstraints { make in
      make.top.equalTo(segmentedControl.snp.bottom).offset(12)
      make.bottom.leading.trailing.equalToSuperview()
    }
  }
  
  private func setupBinding() {
    
  }
  
  private func show(_ vc: BaseViewController) {
    
    if let currentVC {
      currentVC.willMove(toParent: nil)
      currentVC.view.removeFromSuperview()
      currentVC.removeFromParent()
    }

    addChild(vc)
    vc.view.frame = containerView.bounds
    containerView.addSubview(vc.view)
    vc.didMove(toParent: self)

    currentVC = vc
  }
}

extension PlaceViewController: SegmentedControlDelegate {
  public func segmentedControl(_ segmentedControl: SegmentedControl, didSelectSegmentAt index: Int) {
    viewModel.send(input: .selectSegment(index: index))
  }
}

#if targetEnvironment(simulator)
  @available(iOS 17.0, *)
  #Preview {
    let viewModel = PlaceViewModel()
    let placeViewController = PlaceViewController(viewModel: viewModel)

    return placeViewController
  }
#endif
