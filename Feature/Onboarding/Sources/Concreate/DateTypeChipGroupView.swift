//
//  DateTypeChipGroupView.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/26/25.
//

import UIKit
import SnapKit
import Then

// MARK: - DateTypeChipGroupViewDelegate
protocol DateTypeChipGroupViewDelegate: AnyObject {
    func dateTypeChipGroupView(_ view: DateTypeChipGroupView, didSelectDateType dateType: String?)
}

// MARK: - DateTypeChipGroupView
class DateTypeChipGroupView: UIView, DateTypeChipViewDelegate {

    weak var delegate: DateTypeChipGroupViewDelegate?

    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
        $0.alignment = .center
    }

    private var chipViews: [DateTypeChipView] = []
    
    private var selectedDateType: String? {
        didSet {
            delegate?.dateTypeChipGroupView(self, didSelectDateType: selectedDateType)
        }
    }
    
    private let emptySpaceView : UIView = UIView().then {
        $0.backgroundColor = .clear
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addDateTypeOptions()
    }

    // MARK: 해당 함수 public으로 수정 시 원하는 버튼 추가 가능
    private func addDateTypeOptions() {
        let solarChip = DateTypeChipView().then {
            $0.title = "양력"
            $0.delegate = self
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        chipViews.append(solarChip)
        stackView.addArrangedSubview(solarChip)

        let lunarNormalChip = DateTypeChipView().then {
            $0.title = "음/평달"
            $0.delegate = self
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        chipViews.append(lunarNormalChip)
        stackView.addArrangedSubview(lunarNormalChip)

        let lunarLeapChip = DateTypeChipView().then {
            $0.title = "음/윤달"
            $0.delegate = self
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        
        chipViews.append(lunarLeapChip)
        stackView.addArrangedSubview(lunarLeapChip)
        
        stackView.addArrangedSubview(emptySpaceView)

        selectChip(at: 0)
    }

    private func selectChip(at index: Int) {
        guard index < chipViews.count else { return }

        for (i, chip) in chipViews.enumerated() {
            chip.isSelected = (i == index)
        }
        selectedDateType = chipViews[index].title
    }

    // MARK: - DateTypeChipViewDelegate
    func dateTypeChipView(_ chipView: DateTypeChipView, didSelect isSelected: Bool) {
        if !chipView.isSelected { // 현재 탭된 칩이 선택되어 있지 않은 경우에만 선택 로직 수행
            for (i, chip) in chipViews.enumerated() {
                if chip === chipView {
                    selectChip(at: i)
                    break
                }
            }
        }
    }
}
