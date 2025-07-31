//
//  AgreementViewController.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/30/25.
//

import UIKit
import DesignSystem

import SnapKit
import Then


protocol AgreementViewDelegate : AnyObject {
    func agreementViewDidComplete()
}

final class AgreementViewController : UIViewController {
    
    weak var delegate : AgreementViewDelegate?
    
    private var agreementItems : [AgreementItem] = [
        AgreementItem(id: .all, title: "전체 동의", isRequired: false, isAgreed: false, hasDetail: false),
        AgreementItem(id: .service, title: "서비스 이용 약관", isRequired: true, isAgreed: false, hasDetail: true),
        AgreementItem(id: .privacy, title: "개인정보 수집 및 이용", isRequired: true, isAgreed: false, hasDetail: true),
        AgreementItem(id: .age, title: "만 14세 이상", isRequired: true, isAgreed: false, hasDetail: false)
    ]
    
    private var isAllAgree : Bool {
        return agreementItems.filter {$0.isRequired }.allSatisfy { $0.isAgreed } || agreementItems[0].isAgreed
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = STColors.white.color
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    private lazy var titleLabel: UILabel = UILabel().then {
        let style = Typography.Body_18_B
        style.color = STColors.gray1.color
        $0.style = style
        $0.styledText = "약관에 동의해주세요"
    }
    
    private lazy var closeButton = UIButton().then {
        $0.setImage(STImages.xMark.image, for: .normal)
    }
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize // 셀 높이 자동 계산
        layout.minimumLineSpacing = 0 // 셀 사이 간격
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AgreementCell.self, forCellWithReuseIdentifier: AgreementCell.identifier)
        return collectionView
    }()
    
    private lazy var confirmButton : UIButton = UIButton().then {
        $0.backgroundColor = STColors.primary7.color
        $0.layer.cornerRadius = 8
        var style = Typography.Body_18_B
        style.color = STColors.white.color
        let styled = "확인".set(style: style)
        $0.setAttributedTitle(styled, for: .normal)
        $0.isEnabled = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestures()
        bindActions()
    }
}

extension AgreementViewController {
    func setupView() {
        view.backgroundColor = STColors.black.color.withAlphaComponent(0.5)
        
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(collectionView)
        containerView.addSubview(confirmButton)
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.5) // 화면 높이의 60% 차지 (조정 가능)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(32)
        }
        
        closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalTo(titleLabel)
            $0.width.height.equalTo(24)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(confirmButton.snp.top).offset(-28)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().offset(-56)
            $0.height.equalTo(56)
        }
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        tapGesture.delegate = self // 델리게이트 설정
        view.addGestureRecognizer(tapGesture)
    }
    
    private func bindActions() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    private func updateConfrimButton() {
        confirmButton.backgroundColor = isAllAgree ? STColors.primary2.color : STColors.primary7.color
        if isAllAgree { confirmButton.isEnabled = true }
        else { confirmButton.isEnabled = false }
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: false, completion: nil)
    }

    @objc private func confirmButtonTapped() {
        delegate?.agreementViewDidComplete()
    }
    
    @objc private func handleBackgroundTap() {
        dismiss(animated: false)
    }
}

extension AgreementViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return agreementItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AgreementCell.identifier, for: indexPath) as? AgreementCell else {
            fatalError("Unable to dequeue AgreementCell")
        }
        let item = agreementItems[indexPath.item]
        cell.configure(with: item)
        cell.delegate = self
        
        return cell
    }
    
    // viewForSupplementaryElementOfKind 메서드 제거
}

extension AgreementViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 44) // 일반 약관 셀 높이
    }
}

extension AgreementViewController: AgreementCellDelegate {
    func agreementCell(_ cell: AgreementCell, didChangeAgreement isAgreed: Bool) {
        if let indexPath = collectionView.indexPath(for: cell) {
            if indexPath.item == 0 {
                let shouldAgreeAll = isAgreed
                for i in 0..<agreementItems.count {
                    agreementItems[i].isAgreed = shouldAgreeAll
                }
                collectionView.reloadData()
            } else {
                agreementItems[indexPath.item].isAgreed = isAgreed
            }
            updateConfrimButton()
        }
    }

    func agreementCellDidTapDetail(_ cell: AgreementCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let item = agreementItems[indexPath.item]
            // TODO: 약관 상세 화면으로 이동
        }
    }
}

extension AgreementViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view
    }
}
