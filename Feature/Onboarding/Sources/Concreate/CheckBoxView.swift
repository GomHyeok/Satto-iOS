//
//  DontKnowTimeView.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/27/25.
//

import UIKit
import SnapKit
import Then
import DesignSystem // DesignSystem 모듈에 접근할 수 있다고 가정


class CheckBoxView : UIView {

    private let checkboxImageView = UIImageView().then {
        // 이미지 에셋 이름을 여기에 사용합니다.
        // 예를 들어, 프로젝트의 Assets.xcassets에 'checkbox_normal'과 'checkbox_selected' 이미지가 있다고 가정합니다.
        $0.image = UIImage(named: "checkbox_normal") // 기본 이미지
        $0.contentMode = .scaleAspectFit
        $0.tintColor = DesignSystemAsset.Colors.gray3.color // 체크박스 색상 (시스템 이미지 사용 시)
    }

    private let titleLabel = UILabel().then {
        $0.text = "몰랐어요"
        $0.font = Typography.Body_14_M.font?.font(size: 14) // 폰트 스타일 조정
        $0.textColor = DesignSystemAsset.Colors.gray3.color
    }

    var isSelected: Bool = false {
        didSet {
            updateAppearance()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(checkboxImageView)
        addSubview(titleLabel)

        checkboxImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(20) // 체크박스 이미지 크기 (조정 가능)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkboxImageView.snp.trailing).offset(4) // 이미지와 텍스트 간격
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview() // 오토레이아웃 경고 방지
        }
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    private func updateAppearance() {
        if isSelected {
            // 선택된 이미지: 예시로 `checkbox_selected` 에셋 이름 사용
            checkboxImageView.image = UIImage(named: "checkbox_selected") ?? UIImage(systemName: "checkmark.square.fill")
            // System Image를 사용한다면 틴트 컬러 변경도 가능합니다.
            checkboxImageView.tintColor = DesignSystemAsset.Colors.primary7.color // 선택 시 색상
        } else {
            // 기본 이미지: 예시로 `checkbox_normal` 에셋 이름 사용
            checkboxImageView.image = UIImage(named: "checkbox_normal") ?? UIImage(systemName: "square")
            checkboxImageView.tintColor = DesignSystemAsset.Colors.gray3.color // 기본 색상
        }
    }

    @objc private func handleTap() {
        isSelected.toggle() // 상태 토글
    }
}
