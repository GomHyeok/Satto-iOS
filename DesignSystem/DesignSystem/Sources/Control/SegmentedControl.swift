//
//  SegmentedControl.swift
//  DesignSystemLayer
//
//  Created by 최재혁 on 3/10/26.
//

import UIKit
import Combine
import Then

public protocol SegmentedControlDelegate: AnyObject {
  func segmentedControl(_ segmentedControl: SegmentedControl, didSelectSegmentAt index: Int)
}

public final class SegmentedControl: UIView {
  public enum Style: CaseIterable {
    case primary
    case gray
    
    fileprivate var backgroundColor: UIColor {
      switch self {
      case .primary:
        return STColors.primary8.color
      case .gray:
        return STColors.gray8.color
      }
    }
  }
  
  public weak var delegate: SegmentedControlDelegate?
  
  private var isFirstSelected: Bool = true {
    didSet {
      delegate?.segmentedControl(self, didSelectSegmentAt: isFirstSelected ? 0 : 1)
    }
  }
  
  private var firstTitle: String = ""
  private var secondTitle: String = ""
  
  private lazy var stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    $0.alignment = .center
    $0.spacing = 4
  }
  
  private lazy var firstButton = UIButton().then {
    $0.setTitleColor(STColors.gray5.color, for: .normal)
    $0.setTitleColor(STColors.gray2.color, for: .selected)
    $0.layer.cornerRadius = 4
    $0.clipsToBounds = true
  }
  
  private lazy var secondButton = UIButton().then {
    $0.setTitleColor(STColors.gray5.color, for: .normal)
    $0.setTitleColor(STColors.gray2.color, for: .selected)
    $0.layer.cornerRadius = 4
    $0.clipsToBounds = true
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func setupView() {
    addSubview(stackView)
    stackView.addArrangedSubview(firstButton)
    stackView.addArrangedSubview(secondButton)
    
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(4)
    }
    
    firstButton.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    secondButton.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    firstButton.addTarget(self, action: #selector(firstTapped), for: .touchUpInside)
    secondButton.addTarget(self, action: #selector(secondTapped), for: .touchUpInside)
  }
  
  public func update(firstTitle: String, secondTitle: String, style: Style = .primary) {
    self.firstTitle = firstTitle
    self.secondTitle = secondTitle
    self.backgroundColor = style.backgroundColor
    updateSelectionUI()
  }
  
  @objc
  private func firstTapped() {
    guard !isFirstSelected else { return }
    isFirstSelected = true
    updateSelectionUI()
  }

  @objc
  private func secondTapped() {
    guard isFirstSelected else { return }
    isFirstSelected = false
    updateSelectionUI()
  }
  
  private func updateSelectionUI() {
    firstButton.isSelected = isFirstSelected
    secondButton.isSelected = !isFirstSelected

    firstButton.backgroundColor = isFirstSelected ? STColors.white.color : .clear
    secondButton.backgroundColor = !isFirstSelected ? STColors.white.color : .clear
    
    let firstStyle = Typography.Body_14_SB
    let secondStyle = Typography.Body_14_SB

    firstStyle.color = isFirstSelected ? STColors.gray2.color : STColors.gray5.color
    secondStyle.color = isFirstSelected ? STColors.gray5.color : STColors.gray2.color

    firstButton.setAttributedTitle(firstTitle.set(style: firstStyle), for: .normal)
    secondButton.setAttributedTitle(secondTitle.set(style: secondStyle), for: .normal)
  }
}

#if targetEnvironment(simulator)
@available(iOS 17.0, *)
#Preview {
  let segmentedControl = SegmentedControl()
  segmentedControl.update(firstTitle: "첫 번째", secondTitle: "두 번째")
  segmentedControl.snp.makeConstraints { make in
    make.width.equalTo(200)
    make.height.equalTo(40)
  }
  return segmentedControl
}
#endif
