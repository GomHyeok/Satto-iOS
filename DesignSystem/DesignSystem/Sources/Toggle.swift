//
//  Toggle.swift
//  DesignSystem
//
//  Created by ttozzi on 7/31/25.
//

import UIKit

public final class Toggle: UISwitch {

  override public var isEnabled: Bool {
    didSet {
      updateUI(isEnabled)
    }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  private func setupUI() {
    onTintColor = STColors.primary1.color
    snp.makeConstraints { make in
      make.width.equalTo(51)
    }
  }

  private func updateUI(_ isEnabled: Bool) {
    if isEnabled {
      onTintColor = STColors.primary1.color
    } else {
      onTintColor = STColors.primary9.color
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 20
    $0.alignment = .leading
  }
  let activeStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 20
    $0.alignment = .center
  }
  let activeDefaultLabel = UILabel().then {
    $0.text = "Default"
    $0.style = Typography.Body_14_M
  }
  let activeDefaultToggle = Toggle().then {
    $0.isOn = true
    $0.isEnabled = true
  }
  let activeDisabledLabel = UILabel().then {
    $0.text = "Disabled"
    $0.style = Typography.Body_14_M
  }
  let activeDisabledToggle = Toggle().then {
    $0.isOn = true
    $0.isEnabled = false
  }
  activeStackView.addArrangedSubview(activeDefaultLabel)
  activeStackView.addArrangedSubview(activeDefaultToggle)
  activeStackView.addArrangedSubview(activeDisabledLabel)
  activeStackView.addArrangedSubview(activeDisabledToggle)

  let inactiveStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 20
    $0.alignment = .center
  }
  let inactiveDefaultLabel = UILabel().then {
    $0.text = "Default"
    $0.style = Typography.Body_14_M
  }
  let inactiveDefaultToggle = Toggle().then {
    $0.isOn = false
    $0.isEnabled = true
  }
  let inactiveDisabledLabel = UILabel().then {
    $0.text = "Disabled"
    $0.style = Typography.Body_14_M
  }
  let inactiveDisabledToggle = Toggle().then {
    $0.isOn = false
    $0.isEnabled = false
  }

  inactiveStackView.addArrangedSubview(inactiveDefaultLabel)
  inactiveStackView.addArrangedSubview(inactiveDefaultToggle)
  inactiveStackView.addArrangedSubview(inactiveDisabledLabel)
  inactiveStackView.addArrangedSubview(inactiveDisabledToggle)

  let activeTitleLabel = UILabel().then {
    $0.text = "Control/Toggle/Active"
    $0.style = Typography.Heading_20_B
  }
  let inactiveTitleLabel = UILabel().then {
    $0.text = "Control/Toggle/Inactive"
    $0.style = Typography.Heading_20_B
  }
  stackView.addArrangedSubview(activeTitleLabel)
  stackView.addArrangedSubview(activeStackView)
  stackView.addArrangedSubview(inactiveTitleLabel)
  stackView.addArrangedSubview(inactiveStackView)

  return stackView
}
