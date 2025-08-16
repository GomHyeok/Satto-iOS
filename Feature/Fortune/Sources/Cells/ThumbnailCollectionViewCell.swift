//
//  ThumbnailCollectionViewCell.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/13/25.
//

import Base
import DesignSystem
import Extension
import NetworkCore
import UIKit

struct ThumbnailCollectionViewCellModel {
  let name: String
  let birthDate: String
  let bornTime: String
  let sajuMyeongSik: ThumbnailRO
  let day: String
  let strongInfo: String
  let weakInfo: String
}

enum StrengthType {
  case strong
  case weak
}

final class ThumbnailCollectionViewCell: BaseCollectionViewCell {
  private lazy var contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 10
    $0.alignment = .center
  }

  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Body_18_B
    $0.textColor = STColors.gray2.color
    $0.styledText = "한눈에 보는 사주"
  }

  private lazy var descriptionStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 4
    $0.alignment = .leading
  }

  private lazy var nicknameLabel = UILabel().then {
    $0.style = Typography.Caption_12_M
    $0.textColor = STColors.gray3.color
  }

  private lazy var birthDateLabel = UILabel().then {
    $0.style = Typography.Caption_12_M
    $0.textColor = STColors.gray3.color
  }

  private lazy var bornTimeLabel = UILabel().then {
    $0.style = Typography.Caption_12_M
    $0.textColor = STColors.gray3.color
  }

  private lazy var sajuMyeongSikStackView = UIStackView().then {
    $0.axis = .vertical
    $0.layer.cornerRadius = 10
    $0.backgroundColor = STColors.white.color
  }

  private lazy var juLabelStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fill
    $0.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 12, right: 0)
    $0.isLayoutMarginsRelativeArrangement = true
  }

  private lazy var juStackView = UIStackView().then {
    $0.axis = .horizontal
  }

  private lazy var jeStackView = UIStackView().then {
    $0.axis = .horizontal
  }

  private lazy var jeLabelStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fill
    $0.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 12, right: 0)
    $0.isLayoutMarginsRelativeArrangement = true
  }

  private lazy var fortuneStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
    $0.alignment = .center
    $0.backgroundColor = STColors.white.color
    $0.layer.cornerRadius = 10
    $0.layoutMargins = UIEdgeInsets(top: 10, left: 12, bottom: 12, right: 12)
    $0.isLayoutMarginsRelativeArrangement = true
  }

  private lazy var dayLabel = UILabel().then {
    $0.style = Typography.Body_14_SB
    $0.textColor = STColors.gray4.color
  }

  private lazy var strengthStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fill
    $0.spacing = 4
    $0.backgroundColor = STColors.gray9.color
    $0.layer.cornerRadius = 6
    $0.isLayoutMarginsRelativeArrangement = true
    $0.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
  }

  private lazy var fortuneLabel = UILabel().then {
    $0.style = Typography.Body_14_R
    $0.textColor = STColors.gray4.color
    $0.numberOfLines = 2
    $0.textAlignment = .center
    $0.lineBreakMode = .byCharWrapping
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

    contentView.addSubview(titleLabel)
    contentView.addSubview(descriptionStackView)
    contentView.addSubview(contentStackView)

    contentStackView.addArrangedSubview(sajuMyeongSikStackView)
    contentStackView.addArrangedSubview(fortuneStackView)

    sajuMyeongSikStackView.addArrangedSubview(juLabelStackView)
    sajuMyeongSikStackView.addArrangedSubview(juStackView)
    sajuMyeongSikStackView.addArrangedSubview(jeStackView)
    sajuMyeongSikStackView.addArrangedSubview(jeLabelStackView)

    fortuneStackView.addArrangedSubview(dayLabel)
    fortuneStackView.addArrangedSubview(strengthStackView)
    fortuneStackView.addArrangedSubview(fortuneLabel)

    titleLabel.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview().inset(24)
    }

    descriptionStackView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(4)
      make.leading.equalToSuperview().inset(24)
    }

    contentStackView.snp.makeConstraints { make in
      make.top.equalTo(descriptionStackView.snp.bottom).offset(12)
      make.leading.trailing.bottom.equalToSuperview().inset(24)
    }

    sajuMyeongSikStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
    }

    fortuneStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
    }

    fortuneStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
    }

    strengthStackView.snp.makeConstraints { make in
      make.leading.trailing.equalTo(fortuneStackView.layoutMarginsGuide)
    }

    let descriptionLabels = [nicknameLabel, birthDateLabel, bornTimeLabel]
    descriptionLabels.enumerated().forEach { index, label in
      descriptionStackView.addArrangedSubview(label)
      if index < descriptionLabels.count - 1 {
        let ellipse = UIImageView(image: STImages.ellipse.image)
        ellipse.tintColor = STColors.gray6.color
        descriptionStackView.addArrangedSubview(ellipse)
      }
    }
  }

  func update(with cellModel: ThumbnailCollectionViewCellModel) {
    nicknameLabel.styledText = cellModel.name
    birthDateLabel.styledText = cellModel.birthDate
    bornTimeLabel.styledText = cellModel.bornTime

    dayLabel.styledText = "\(cellModel.day)년 토정비결"
    fortuneLabel.styledText = cellModel.sajuMyeongSik.overallFortuneText.insertLineBreaks(every: 20)

    if let pair = cellModel.sajuMyeongSik.sajuMyeongSik.siJu {
      addLabel(pair: pair)
    } else {
      addLabel(pair: SajuPair(cheonGan: "시주 없음", jiji: "시주 없음"))
    }
    addLabel(pair: cellModel.sajuMyeongSik.sajuMyeongSik.ilJu)
    addLabel(pair: cellModel.sajuMyeongSik.sajuMyeongSik.wolJu)
    addLabel(pair: cellModel.sajuMyeongSik.sajuMyeongSik.nyeongJu)

    createSajuTypeLabel()

    let strongStack = createStrength(info: cellModel.strongInfo, type: .strong)
    let weakStack = createStrength(info: cellModel.weakInfo, type: .weak)
    let separatorView = UIView().then {
      $0.layer.borderWidth = 1
      $0.layer.borderColor = STColors.gray7.color.cgColor
      $0.clipsToBounds = true
    }

    separatorView.snp.makeConstraints { make in
      make.height.equalTo(24)
      make.width.equalTo(1)
    }
    strengthStackView.addArrangedSubview(strongStack)
    strengthStackView.addArrangedSubview(separatorView)
    strengthStackView.addArrangedSubview(weakStack)

    strongStack.snp.makeConstraints { make in
      make.width.equalTo(weakStack.snp.width)
    }
  }
}

extension ThumbnailCollectionViewCell {
  func getElement(for hanja: String) -> FiveElements? {
    switch hanja {
    case "甲", "乙", "寅", "卯":
      return .wood
    case "丙", "丁", "巳", "午":
      return .fire
    case "戊", "己", "辰", "戌", "丑", "未":
      return .earth
    case "庚", "辛", "申", "酉":
      return .metal
    case "壬", "癸", "亥", "子":
      return .water
    default:
      return nil  // 해당하는 오행이 없는 경우
    }
  }

  func createSajuTypeLabel() {
    let juLabels = ["시주", "일주", "월주", "년주"]
    var juLabelViews: [UILabel] = []
    juLabels.forEach { label in
      let juLabel = UILabel().then {
        $0.style = Typography.Body_16_SB
        $0.textColor = STColors.gray2.color
        $0.styledText = label
        $0.textAlignment = .center
      }
      juLabelViews.append(juLabel)
      juLabelStackView.addArrangedSubview(juLabel)
    }

    // juLabelViews의 모든 레이블에 equalWidth 제약 조건 추가
    if juLabelViews.count > 1 {
      for i in 1..<juLabelViews.count {
        juLabelViews[i].snp.makeConstraints { make in
          make.width.equalTo(juLabelViews[0].snp.width)
        }
      }
    }

    juLabels.dropLast().enumerated().forEach { index, _ in
      let separatorView = UIView().then {
        $0.backgroundColor = STColors.gray7.color
      }
      separatorView.snp.makeConstraints { make in
        make.height.equalTo(24)
        make.width.equalTo(1)
      }
      juLabelStackView.insertArrangedSubview(separatorView, at: index * 2 + 1)
    }

    // jeLabelStackView도 동일하게 적용
    let jeLabels = ["정재", "겁재", "정재", "겁재"]
    var jeLabelViews: [UILabel] = []
    jeLabels.forEach { label in
      let jeLabel = UILabel().then {
        $0.style = Typography.Body_16_SB
        $0.textColor = STColors.gray2.color
        $0.styledText = label
        $0.textAlignment = .center
      }
      jeLabelViews.append(jeLabel)
      jeLabelStackView.addArrangedSubview(jeLabel)
    }

    if jeLabelViews.count > 1 {
      for i in 1..<jeLabelViews.count {
        jeLabelViews[i].snp.makeConstraints { make in
          make.width.equalTo(jeLabelViews[0].snp.width)
        }
      }
    }

    jeLabels.dropLast().enumerated().forEach { index, _ in
      let separatorView = UIView().then {
        $0.backgroundColor = STColors.gray7.color
      }
      separatorView.snp.makeConstraints { make in
        make.height.equalTo(24)
        make.width.equalTo(1)
      }
      jeLabelStackView.insertArrangedSubview(separatorView, at: index * 2 + 1)
    }
  }

  func createSajuLabel(value: String) -> UILabel {
    let element = getElement(for: value) ?? .earth
    let label = UILabel().then {
      $0.style = Typography.Display_28_B
      $0.textColor = STColors.white.color
      $0.styledText = value
      $0.backgroundColor = element.color
      $0.layer.borderWidth = 0.5
      $0.layer.borderColor = STColors.gray9.color.cgColor
      $0.clipsToBounds = true
      $0.textAlignment = .center
    }

    label.snp.makeConstraints { make in
      make.height.equalTo(label.snp.width)
    }

    return label
  }

  func addLabel(pair: SajuPair) {
    let juLabel = createSajuLabel(value: pair.cheonGan)
    juStackView.addArrangedSubview(juLabel)

    let jeLabel = createSajuLabel(value: pair.jiji)
    jeStackView.addArrangedSubview(jeLabel)
  }

  func createStrength(info: String, type: StrengthType) -> UIStackView {
    let stackView = UIStackView().then {
      $0.axis = .horizontal
      $0.backgroundColor = .clear
      $0.distribution = .equalSpacing
    }

    let type = type == .strong ? "강한 기운" : "약한 기운"
    let element = getElement(for: info)

    let typeLabel = UILabel().then {
      $0.style = Typography.Caption_12_SB
      $0.textColor = STColors.gray3.color
      $0.styledText = type
    }

    let infoLabel = PaddingLabel().then {
      $0.style = Typography.Body_14_SB
      $0.textColor = STColors.white.color
      $0.backgroundColor = element?.color
      $0.layer.borderWidth = 1.0
      $0.layer.borderColor = element?.color.cgColor
      $0.textAlignment = .center
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 13
      $0.styledText = element?.kor ?? "알 수 없음"
      $0.contentInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    infoLabel.snp.makeConstraints { make in
      make.height.equalTo(28)
    }

    stackView.addArrangedSubview(typeLabel)
    stackView.addArrangedSubview(infoLabel)

    return stackView
  }
}

@available(iOS 17.0, *)
#Preview {
  let cell = ThumbnailCollectionViewCell()
  let cellModel = ThumbnailCollectionViewCellModel(
    name: "홍길동",
    birthDate: "1990년 1월 1일",
    bornTime: "오전 10시",
    sajuMyeongSik: ThumbnailRO(
      sajuMyeongSik: SajuMyeongSik(
        siJu: SajuPair(cheonGan: "甲", jiji: "寅"),
        ilJu: SajuPair(cheonGan: "乙", jiji: "卯"),
        wolJu: SajuPair(cheonGan: "丙", jiji: "巳"),
        nyeongJu: SajuPair(cheonGan: "丁", jiji: "午")
      ),
      overallFortuneText: "근심과 즐거움이 상반하니 세월의 흐름을 잘 읽어보시게"
    ),
    day: "2025",
    strongInfo: "甲",
    weakInfo: "丙"
  )

  cell.update(with: cellModel)
  return cell
}
