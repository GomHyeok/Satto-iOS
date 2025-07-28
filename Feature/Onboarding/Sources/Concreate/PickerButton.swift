//
//  PickerButton.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/28/25.
//

import UIKit
import DesignSystem

import SnapKit
import Then

class PickerButton : UIButton {
    private let placeholderLabel = UILabel().then {
        var style = Typography.Body_14_M
        style.color = STColors.gray5.color
        $0.attributedText = "Placeholder".set(style: style)
        $0.isUserInteractionEnabled = false
    }

    private let dropdownImageView = UIImageView().then {
        $0.image = STImages.dropdown.image // 드롭다운 아이콘
        $0.contentMode = .scaleAspectFit
        $0.tintColor = STColors.gray5.color
        $0.isUserInteractionEnabled = false
    }
    
    public var placeholder: String? {
        didSet {
            updateText()
        }
    }

    public var selectedItem: String? {
        didSet {
            updateText()
        }
    }
    
    var isActive : Bool = false {
        didSet {
            updateBorderColor()
        }
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
            layer.borderColor = isEnabled ? STColors.primary2.color.cgColor : STColors.gray7.color.cgColor
        }
    }

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupView() {
        self.backgroundColor = .clear // 배경 투명
        self.layer.borderWidth = 1
        self.layer.borderColor = STColors.gray5.color.cgColor
        self.layer.cornerRadius = 6
        self.clipsToBounds = true

        addSubview(placeholderLabel)
        addSubview(dropdownImageView)

        // Placeholder Label 제약 조건
        placeholderLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(dropdownImageView.snp.leading).offset(-8) // 드롭다운 이미지와의 간격
        }

        // Dropdown Image View 제약 조건
        dropdownImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-14)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20) // 이미지 크기 고정 (예시: 20x20)
        }
        
        // 버튼의 최소 높이 설정 (텍스트 필드와 유사하게 44pt)
        self.snp.makeConstraints {
            $0.height.equalTo(43)
        }

        updateText()
        updateBorderColor()
    }

    // MARK: - Update Text
    private func updateText() {
        if let selected = selectedItem, !selected.isEmpty {
            let style = Typography.Body_14_M
            style.color = STColors.gray1.color
            placeholderLabel.attributedText = selected.set(style: style)
        } else {
            let style = Typography.Body_14_M
            style.color = STColors.gray5.color
            placeholderLabel.attributedText = (placeholder ?? "Placeholder").set(style: style)
        }
    }
    
    private func updateBorderColor() {
        if isActive {
            self.layer.borderColor = STColors.primary2.color.cgColor
            self.dropdownImageView.transform = CGAffineTransform(rotationAngle: .pi)
            self.backgroundColor = .clear
        } else {
            self.layer.borderColor = STColors.gray7.color.cgColor
            self.dropdownImageView.transform = CGAffineTransform(rotationAngle: .pi)
            self.backgroundColor = .clear
        }
        
        if !isEnabled {
            self.layer.borderColor = STColors.gray8.color.cgColor
            self.backgroundColor = STColors.gray8.color
            
            let style = Typography.Body_14_M
            style.color = STColors.gray5.color
            placeholderLabel.attributedText = "입력하지 않아도 괜찮아요".set(style: style)
        } else {
            self.backgroundColor = STColors.gray7.color
            updateText()
        }
    }
}
