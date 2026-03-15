//
//  CountView.swift
//  FeatureLayer
//
//  Created by 최재혁 on 3/12/26.
//

import UIKit
import Then
import SnapKit

import DesignSystem

final class CountView: UIView {
  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 3
    $0.layer.borderWidth = 1
    $0.layer.borderColor = STColors.gray8.color.cgColor
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 4
    $0.alignment = .center
    $0.distribution = .fill
  }
  
  private let titleLabel = UILabel().then {
    $0.style = Typography.Caption_12_M
    $0.textColor = STColors.gray4.color
  }
  
  private let dotView = UIView().then {
    $0.backgroundColor = STColors.gray4.color
    $0.layer.cornerRadius = 1.5
  }
  
  private let countLabel = UILabel().then {
    $0.style = Typography.Caption_12_M
    $0.textColor = STColors.gray4.color
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  
  private func setupUI() {
    addSubview(containerView)
    containerView.addSubview(stackView)
    
    [titleLabel, dotView, countLabel].forEach {
      stackView.addArrangedSubview($0)
    }
    
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    stackView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview().inset(2)
      make.leading.trailing.equalToSuperview().inset(4)
    }
    
    dotView.snp.makeConstraints { make in
      make.size.equalTo(3)
    }
  }
  
  // 데이터를 업데이트하기 위한 메서드
  func update(title: String, count: String) {
    titleLabel.styledText = title
    countLabel.styledText = count
  }
}


#if targetEnvironment(simulator)
@available(iOS 17.0, *)
#Preview {
  let countView = CountView()
  countView.update(title: "참여자", count: "123")
  
  return countView
}
#endif

