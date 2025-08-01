//
//  SendFeedbackCollectionViewCell.swift
//  Setting
//
//  Created by ttozzi on 7/26/25.
//

import DesignSystem
import SnapKit
import Then
import UIKit

struct SendFeedbackCollectionViewCellModel {
  let description: String?
  let feedbackButtonTitle: String?
}

final class SendFeedbackCollectionViewCell: UICollectionViewCell {
  
  private lazy var contentStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 14
  }
  private lazy var feedbackAreaStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .leading
    $0.spacing = 12
  }
  private lazy var descriptionLabel = UILabel().then {
    $0.style = Typography.Body_14_SB
    $0.numberOfLines = 2
  }
  private lazy var sendFeedbackButton = UIButton().then {
    $0.backgroundColor = STColors.primary8.color // TODO: 버튼 컴포넌트
    $0.isUserInteractionEnabled = false
  }
  private lazy var imageView = UIImageView().then {
    $0.backgroundColor = .gray // TODO: 이미지 리소스 확인 필요
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    backgroundColor = .clear
    contentStackView.backgroundColor = .clear
    
    contentView.addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(20)
    }
    
    contentStackView.addArrangedSubview(feedbackAreaStackView)
    feedbackAreaStackView.addArrangedSubview(descriptionLabel)
    feedbackAreaStackView.addArrangedSubview(sendFeedbackButton)
    
    contentStackView.addArrangedSubview(imageView)
  }
  
  func update(with cellModel: SendFeedbackCollectionViewCellModel) {
    descriptionLabel.styledText = cellModel.description
    sendFeedbackButton.setTitle(cellModel.feedbackButtonTitle, for: .normal)
  }
}

@available(iOS 17.0, *)
#Preview {
  let cellModel = SendFeedbackCollectionViewCellModel(
    description: "더 나은 서비스를 위해,\n여러분의 목소리를 들려주세요",
    feedbackButtonTitle: "의견 보내기"
  )
  let cell = SendFeedbackCollectionViewCell()
  cell.update(with: cellModel)
  return cell
}
