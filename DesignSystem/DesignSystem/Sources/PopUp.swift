//
//  PopUp.swift
//  DesignSystemLayer
//
//  Created by 최재혁 on 8/18/25.
//

import SnapKit
import Then
import UIKit

public final class PopUp : UIView {
  
  public enum Style : CaseIterable {
    case one
    case two
    
    fileprivate var isHidden: Bool {
      switch self {
      case .one:
        return true
      case .two:
        return false
      }
    }
  }
  private lazy var contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .center
  }
  
  private(set) lazy var deleteButton = UIButton().then {
    $0.setImage(STImages.xMark.image, for: .normal)
  }
  
  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Heading_20_B
    $0.textColor = STColors.gray1.color
    $0.textAlignment = .center
  }
  
  private lazy var descriptionLabel = UILabel().then {
    $0.style = Typography.Body_16_M
    $0.textColor = STColors.gray4.color
    $0.textAlignment = .center
    $0.numberOfLines = 2
  }
  
  private lazy var buttonStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 8
    $0.alignment = .center
    $0.distribution = .fillEqually
  }
  
  public private(set) lazy var outButton = UIButton().then {
    $0.backgroundColor = STColors.gray7.color
    $0.layer.cornerRadius = 8
  }
  
  public private(set) lazy var actionButton = UIButton().then {
    $0.backgroundColor = STColors.primary2.color
    $0.layer.cornerRadius = 8
  }
  
  public init(style : Style? = nil) {
    super.init(frame: .zero)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    layer.cornerRadius = 12
    layer.masksToBounds = true
    backgroundColor = STColors.white.color
    
    addSubview(contentStackView)
    addSubview(deleteButton)
    contentStackView.addArrangedSubview(titleLabel)
    contentStackView.addArrangedSubview(descriptionLabel)
    contentStackView.addArrangedSubview(buttonStackView)
    buttonStackView.addArrangedSubview(outButton)
    buttonStackView.addArrangedSubview(actionButton)
    
    contentStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(24)
    }
    
    contentStackView.setCustomSpacing(8, after: titleLabel)
    contentStackView.setCustomSpacing(24, after: descriptionLabel)
    
    deleteButton.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(24)
      make.trailing.equalToSuperview().inset(24)
      make.width.height.equalTo(16)
    }
    
    buttonStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
    }
    
    outButton.snp.makeConstraints { make in
      make.height.equalTo(48)
    }
    
    actionButton.snp.makeConstraints { make in
      make.height.equalTo(48)
    }
  }
  
  public func update(titile : String, description: String? = nil, actionButtonTitle: String, outButtonTitle: String = "취소") {
    titleLabel.styledText = titile
    descriptionLabel.styledText = description
    let style = Typography.Body_16_B
    style.color = STColors.white.color
    actionButton.setAttributedTitle(actionButtonTitle.set(style: style), for: .normal)
    style.color = STColors.gray1.color
    outButton.setAttributedTitle(outButtonTitle.set(style: style), for: .normal)
  }
  
  public func update(style : Style) {
    outButton.isHidden = style.isHidden
  }
}

@available(iOS 17.0, *)
#Preview {
  let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 16
    $0.alignment = .center
    $0.backgroundColor = .systemBackground
  }
  
  let popup = PopUp().then {
    $0.update(titile: "제목", description: "설명 텍스트입니다.", actionButtonTitle: "확인")
    $0.update(style: .one)
  }
  
  let popupTwo = PopUp().then {
    $0.update(titile: "제목", description: "설명 \n텍스트입니다.", actionButtonTitle: "확인", outButtonTitle: "취소")
    $0.update(style: .two)
  }
  
  stackView.addArrangedSubview(popup)
  stackView.addArrangedSubview(popupTwo)
  
  popup.snp.makeConstraints { make in
    make.width.equalTo(300)
    make.height.equalTo(200)
  }
  
  popupTwo.snp.makeConstraints { make in
    make.width.equalTo(300)
    make.height.equalTo(200)
  }
  
  return stackView
}
