//
//  LottoResultInfoView.swift
//  Home
//
//  Created by ttozzi on 8/18/25.
//

import DesignSystem
import Lottie
import UIKit

struct LottoResultInfoModel {
  let isWinner: Bool
  let roundText: String
  let title: String
  let desciprtion: String
}

final class LottoResultInfoView: UIView {

  private lazy var contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = .zero
    $0.alignment = .center
  }
  private lazy var roundTextChip = SquareTintedChip().then {
    $0.update(style: .primary)
  }
  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Heading_24_B.color(STColors.primary2.color)
  }
  private lazy var descriptionLabel = UILabel().then {
    $0.style = Typography.Body_16_SB.color(STColors.gray2.color)
  }
  private var confettiiiiViews: [LottieAnimationView] = []

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func update(with model: LottoResultInfoModel) {
    confettiiiiViews.forEach {
      $0.isHidden = !model.isWinner
    }
    roundTextChip.update(text: model.roundText)
    titleLabel.styledText = model.title
    descriptionLabel.styledText = model.desciprtion
  }

  private func setupUI() {
    addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(24)
      make.horizontalEdges.equalToSuperview().inset(24)
      make.bottom.equalToSuperview().inset(47)
    }

    contentStackView.addArrangedSubview(roundTextChip)
    contentStackView.setCustomSpacing(16, after: roundTextChip)

    contentStackView.addArrangedSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.height.equalTo(36)
    }
    contentStackView.addArrangedSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints { make in
      make.height.equalTo(24)
    }

    Task { @MainActor in
      if let confettiiiiView1 = await makeConfettiiiiAnimationView() {
        addSubview(confettiiiiView1)
        confettiiiiView1.snp.makeConstraints { make in
          make.top.equalToSuperview().offset(-20)
          make.leading.equalToSuperview().inset(12)
        }
        confettiiiiViews.append(confettiiiiView1)
      }
      if let confettiiiiView2 = await makeConfettiiiiAnimationView() {
        addSubview(confettiiiiView2)
        confettiiiiView2.snp.makeConstraints { make in
          make.trailing.equalToSuperview()
          make.bottom.equalToSuperview().offset(6)
        }
        confettiiiiViews.append(confettiiiiView2)
      }
    }
  }

  private func makeConfettiiiiAnimationView() async -> LottieAnimationView? {
    guard let animationView = await LottieAnimations.loadAnimation(.confettiiii) else {
      return nil
    }
    animationView.loopMode = .loop
    animationView.snp.makeConstraints { make in
      make.size.equalTo(146)
    }
    animationView.play()
    return animationView
  }
}
