//
//  RadioButton.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/26/25.
//

import UIKit
import DesignSystem

import Then
import SnapKit

// MARK: - RadioButtonViewDelegate (단일 라디오 버튼이 선택되었음을 알리는 프로토콜)
protocol RadioButtonViewDelegate: AnyObject {
    func radioButtonView(_ radioButtonView: RadioButtonView, didSelect isSelected: Bool)
}

// MARK: - RadioButtonView (개별 라디오 버튼)
class RadioButtonView: UIView {

    // 델리게이트를 통해 상위 뷰에 선택 상태를 알림
    weak var delegate: RadioButtonViewDelegate?

    // 라디오 버튼의 바깥 원
    private let circleView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = DesignSystemAsset.Colors.gray7.color.cgColor
    }

    // 선택되었을 때 나타나는 안쪽 채워진 원
    private let selectedIndicatorView = UIView().then {
        $0.layer.cornerRadius = 5
        $0.backgroundColor = DesignSystemAsset.Colors.white.color
    }

    // 라디오 버튼 옆의 텍스트 레이블
    private let titleLabel = UILabel()

    // 라디오 버튼의 선택 상태 (true: 선택됨, false: 선택 안 됨)
    var isSelected: Bool = false {
        didSet {
            // isSelected 값이 변경될 때마다 UI 업데이트
            if isSelected {
                circleView.backgroundColor = DesignSystemAsset.Colors.primary1.color
                circleView.layer.borderColor = DesignSystemAsset.Colors.primary1.color.cgColor
            } else {
                circleView.backgroundColor = DesignSystemAsset.Colors.white.color
                circleView.layer.borderColor = DesignSystemAsset.Colors.gray7.color.cgColor
            }
        }
    }

    // 라디오 버튼에 표시될 텍스트
    var title: String? {
        didSet {
            let style = Typography.Body_14_M
            style.color = DesignSystemAsset.Colors.black.color
            titleLabel.attributedText = title?.set(style: style)
        }
    }

    // 코드 기반 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    // 스토리보드/XIB 기반 초기화
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // 뷰의 초기 설정
    private func setupView() {
        // 서브뷰 추가
        addSubview(circleView)
        circleView.addSubview(selectedIndicatorView)
        addSubview(titleLabel)

        // 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)

        circleView.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.leading.equalToSuperview() // 부모 뷰의 왼쪽 가장자리에 붙임
            $0.centerY.equalToSuperview() // 부모 뷰의 중앙에 수직 정렬
        }

        selectedIndicatorView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(circleView)
            $0.width.height.equalTo(10)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(circleView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }

    // 탭 제스처 처리
    @objc private func handleTap() {
        // 델리게이트에게 자신이 선택되었음을 알림
        delegate?.radioButtonView(self, didSelect: true)
    }
}
