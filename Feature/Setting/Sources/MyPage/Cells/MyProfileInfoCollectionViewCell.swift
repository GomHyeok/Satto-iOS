//
//  MyProfileInfoCollectionViewCell.swift
//  Setting
//
//  Created by ttozzi on 7/26/25.
//

import Combine
import DesignSystem
import SnapKit
import Then
import UIKit

struct MyProfileInfoCollectionViewCellModel {
  let nickname: String
  // let profileImageURL: URL?
  let gender: String  // TODO: 데이터 타입 확인 필요
  let birthDate: String  // TODO: 데이터 타입 확인 필요
  let birthTime: String
}

final class MyProfileInfoCollectionViewCell: UICollectionViewCell {

  private lazy var contentStackView = UIStackView().then {
    $0.spacing = .zero
    $0.axis = .vertical
    $0.alignment = .center
  }
  private lazy var profileImageView = UIImageView().then {
    $0.layer.cornerRadius = 44
    $0.clipsToBounds = true
  }
  private lazy var nicknameStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 4
  }
  private lazy var nicknameLabel = UILabel().then {
    $0.style = Typography.Heading_20_B
  }
  private(set) lazy var editButton = UIButton().then {
    let image = STImages.edit2.image.withRenderingMode(.alwaysTemplate)
    $0.setImage(image, for: .normal)
    $0.tintColor = STColors.gray5.color
  }
  private lazy var descriptionStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.spacing = 4
  }
  private lazy var genderLabel = UILabel().then {
    $0.style = Typography.Caption_12_B
  }
  private lazy var birthDateLabel = UILabel().then {
    $0.style = Typography.Caption_12_B
  }
  private lazy var birthTimeLabel = UILabel().then {
    $0.style = Typography.Caption_12_B
  }
  var cancellables = Set<AnyCancellable>()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    profileImageView.backgroundColor = .gray  // TODO: 임시
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    cancellables.removeAll()
  }

  private func setupUI() {
    backgroundColor = .clear
    contentStackView.backgroundColor = .clear

    contentView.addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(20)
    }

    contentStackView.addArrangedSubview(profileImageView)
    contentStackView.setCustomSpacing(16, after: profileImageView)
    profileImageView.snp.makeConstraints { make in
      make.size.equalTo(88)
    }

    contentStackView.addArrangedSubview(nicknameStackView)
    contentStackView.setCustomSpacing(8, after: nicknameStackView)
    nicknameStackView.addArrangedSubview(nicknameLabel)
    nicknameStackView.addArrangedSubview(editButton)

    contentStackView.addArrangedSubview(descriptionStackView)
    let descriptionLabels = [genderLabel, birthDateLabel, birthTimeLabel]
    descriptionLabels.enumerated().forEach { index, label in
      descriptionStackView.addArrangedSubview(label)
      if index < descriptionLabels.count - 1 {
        let ellipse = UIImageView(image: STImages.ellipse.image)
        ellipse.tintColor = STColors.gray6.color
        descriptionStackView.addArrangedSubview(ellipse)
      }
    }
  }

  func update(with cellModel: MyProfileInfoCollectionViewCellModel) {
    nicknameLabel.styledText = "\(cellModel.nickname) 님"
    genderLabel.styledText = cellModel.gender
    birthDateLabel.styledText = cellModel.birthDate
    birthTimeLabel.styledText = cellModel.birthTime
  }
}

@available(iOS 17.0, *)
#Preview {
  let cellModel = MyProfileInfoCollectionViewCellModel(
    nickname: "콩떡",
    gender: "여",
    birthDate: "1999-12-25",
    birthTime: "01:00 ~ 02:59"
  )
  let cell = MyProfileInfoCollectionViewCell()
  cell.update(with: cellModel)
  return cell
}
