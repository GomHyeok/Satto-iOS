//
//  InputSearch.swift
//  DesignSystemLayer
//
//  Created by 최재혁 on 12/30/25.
//

import Then
import UIKit
import Combine

public final class InputSearch : UIView {
  
  private enum State {
    case normal
    case focused
    case filled
    case disabled
  }
  
  private var state : State = .normal {
    didSet {
      update()
    }
  }
  
  private let _textPublisher = PassthroughSubject<String, Never>()
  public var textPublisher: AnyPublisher<String, Never> {
    _textPublisher.eraseToAnyPublisher()
  }
  
  private lazy var backgroundView = UIView().then {
    $0.backgroundColor = STColors.white.color
    $0.layer.cornerRadius = 6
    $0.layer.masksToBounds = true
    $0.layer.borderWidth = 1
    $0.layer.borderColor = STColors.gray7.color.cgColor
  }
  
  private lazy var searchImageView = UIImageView().then {
    $0.image = STImages.search.image.withRenderingMode(.alwaysTemplate)
    $0.contentMode = .center
  }
  
  private lazy var textField = UITextField().then {
    $0.style = Typography.Body_14_M
    $0.placeholder = "PlaceHolder"
    $0.textColor = STColors.black.color
    $0.borderStyle = .none
    $0.delegate = self
    $0.returnKeyType = .search
    $0.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
  }
  
  private lazy var deleteButton = UIButton().then {
    $0.backgroundColor = .clear
    $0.isHidden = true
    $0.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
  }
  
  private lazy var deleteImageView = UIImageView().then {
    $0.image = STImages.xMark.image.withRenderingMode(.alwaysTemplate)
    $0.contentMode = .center
    $0.tintColor = STColors.gray3.color
    $0.isHidden = true
  }
  
  public override init(frame : CGRect) {
    super.init(frame : frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  private func setupView() {
    self.backgroundColor = .clear
    self.state = .normal
    addSubview(backgroundView)
    backgroundView.addSubview(searchImageView)
    backgroundView.addSubview(textField)
    backgroundView.addSubview(deleteButton)
    deleteButton.addSubview(deleteImageView)
    
    backgroundView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    searchImageView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(14)
      make.centerY.equalToSuperview()
      make.width.height.equalTo(16)
    }
    
    textField.snp.makeConstraints { make in
      make.leading.equalTo(searchImageView.snp.trailing).offset(8)
      make.trailing.equalTo(deleteButton.snp.leading).offset(-8)
      make.top.bottom.equalToSuperview()
    }
    
    deleteButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-14)
      make.centerY.equalToSuperview()
      make.width.height.equalTo(16)
    }
    
    deleteImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func update() {
    switch state {
    case .normal:
      searchImageView.tintColor = STColors.primary2.color
      backgroundView.layer.borderColor = STColors.primary2.color.cgColor
      searchImageView.image = STImages.search.image.withRenderingMode(.alwaysTemplate)
      setDeleteButton(true)
    case .focused:
      searchImageView.tintColor = STColors.primary2.color
      backgroundView.layer.borderColor = STColors.primary2.color.cgColor
      searchImageView.image = STImages.search.image.withRenderingMode(.alwaysTemplate)
      setDeleteButton(false)
    case .filled :
      searchImageView.tintColor = STColors.gray3.color
      searchImageView.image = STImages.iconArrow.image
      backgroundView.layer.borderColor = STColors.gray7.color.cgColor
      setDeleteButton(false)
    case .disabled :
      backgroundView.backgroundColor = STColors.gray8.color
      backgroundView.layer.borderColor = STColors.gray8.color.cgColor
    }
  }
  
  private func setDeleteButton(_ isHidden: Bool) {
    deleteButton.isHidden = isHidden
    deleteImageView.isHidden = isHidden
  }
  
  public func setPlaceholder(_ text: String) {
    textField.placeholder = text
  }
  
  @objc private func deleteButtonTapped() {
    textField.text = ""
    state = .normal
    _textPublisher.send("")
  }
  
  @objc private func textFieldEditingChanged(_ textField: UITextField) {
    let text = textField.text ?? ""
    state = .focused
    _textPublisher.send(text)
  }
}

extension InputSearch : UITextFieldDelegate {
  public func textFieldDidBeginEditing(_ textField: UITextField) {
    guard state != .disabled else { return }
    state = .focused
  }
  
  public func textFieldDidEndEditing(_ textField: UITextField) {
    guard state != .disabled else { return }
    state = .normal
  }
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    state = .filled
    return true
  }
}

#if targetEnvironment(simulator)

@available(iOS 17.0, *)
#Preview {
  let inputSearch = InputSearch()
  
  return inputSearch
}

#endif

