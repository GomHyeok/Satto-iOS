//
//  NumberRecommendationCollectionViewCell.swift
//  Home
//
//  Created by ttozzi on 8/7/25.
//

import Base
import Combine
import DesignSystem
import Extension
import UIKit

struct NumberRecommendationCollectionViewCellModel: RecommendationDetailCellModel {
  let roundText: String
  let title: String
  let numbers: [Int]
  var secondsUntilResult: Int { // TODO: 기기 시간 설정을 바꾼 경우, 오후 8시 35분이 지났으나 서버에서 결과 조회가 준비되지 않은 경우 논의 필요
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = .current
    calendar.locale = Locale(identifier: "ko_KR")
    calendar.firstWeekday = 2
    calendar.minimumDaysInFirstWeek = 4
    
    let now = Date()
    guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)),
          let saturday = calendar.date(byAdding: .day, value: 5, to: weekStart),
          let target = calendar.date(bySettingHour: 20, minute: 35, second: 0, of: saturday) else {
      return 0
    }
    
    let diff = target.timeIntervalSince(now)
    if diff >= 0 {
      return Int(diff)
    }
    let next = calendar.date(byAdding: .day, value: 7, to: target)!
    return max(0, Int(next.timeIntervalSince(now)))
  }
}

final class NumberRecommendationCollectionViewCell: BaseCollectionViewCell {

  private lazy var contentStackView = UIStackView().then {
    $0.spacing = 16
    $0.axis = .vertical
    $0.alignment = .center
  }
  private lazy var roundTextChip = PaddingLabel().then {  // TODO: Chip Component
    $0.layer.borderColor = STColors.primary7.color.cgColor
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = 6
    $0.clipsToBounds = true
    $0.style = Typography.Body_14_SB
    $0.textColor = STColors.primary2.color
    $0.textAlignment = .center
    $0.contentInsets = UIEdgeInsets(top: 3.5, left: 10, bottom: 3.5, right: 10)
  }
  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Body_18_B
    $0.textColor = STColors.black.color
  }
  private lazy var numberBallStackView = UIStackView().then {
    $0.spacing = 12
    $0.axis = .horizontal
    $0.alignment = .center
  }
  private lazy var timeUntilDrawLabel = UILabel().then {
    $0.style = Typography.Body_14_SB
    $0.textColor = STColors.gray1.color
    $0.textAlignment = .right
  }
  private var countdownCancellable: AnyCancellable?
  private let timerFinishedSubject = PassthroughSubject<Void, Never>()
  var timerFinished: AnyPublisher<Void, Never> { timerFinishedSubject.eraseToAnyPublisher() }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    countdownCancellable?.cancel()
    countdownCancellable = nil
  }
  
  private func setupUI() {
    contentView.backgroundColor = STColors.white.color
    contentView.layer.cornerRadius = 12
    contentView.clipsToBounds = true

    contentView.addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(24)
      make.leading.trailing.bottom.equalToSuperview().inset(20)
    }

    contentStackView.addArrangedSubview(roundTextChip)
    roundTextChip.snp.makeConstraints { make in
      make.height.equalTo(28)
    }

    contentStackView.addArrangedSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.height.equalTo(27)
    }

    contentStackView.addArrangedSubview(numberBallStackView)
    numberBallStackView.snp.makeConstraints { make in
      make.height.equalTo(40)
    }

    let line = DashedLineView(color: STColors.gray6.color)
    contentStackView.addArrangedSubview(line)
    line.snp.makeConstraints { make in
      make.height.equalTo(1)
      make.width.equalToSuperview()
    }

    let timeUntilDrawStackView = makeTextStackView(
      title: "추첨까지 남은 시간", descriptionLabel: timeUntilDrawLabel)
    contentStackView.addArrangedSubview(timeUntilDrawStackView)
    timeUntilDrawStackView.snp.makeConstraints { make in
      make.width.equalToSuperview()
    }
  }

  func update(with model: NumberRecommendationCollectionViewCellModel) {
    roundTextChip.styledText = model.roundText
    titleLabel.styledText = model.title
    numberBallStackView.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    model.numbers.forEach { number in
      let ball = Ball()
      ball.number = String(number)
      numberBallStackView.addArrangedSubview(ball)
    }
    startCountdown(seconds: model.secondsUntilResult)
  }
  
  private func startCountdown(seconds: Int) {
    countdownCancellable?.cancel()
    
    let secs = max(0, seconds)
    let target = Date().addingTimeInterval(TimeInterval(secs))
    
    countdownCancellable = Timer.publish(every: 1, on: .main, in: .common)
      .autoconnect()
      .handleEvents(receiveSubscription: { [weak self] _ in
        self?.timeUntilDrawLabel.styledText = self?.countdownText(from: Int(target.timeIntervalSinceNow))
      })
      .map { _ in
        return max(0, Int(target.timeIntervalSinceNow))
      }
      .sink { [weak self] remaining in
        self?.timeUntilDrawLabel.styledText = self?.countdownText(from: remaining)
        if remaining == 0 {
          self?.countdownCancellable?.cancel()
          self?.timeUntilDrawLabel.textColor = STColors.red3.color
          self?.timerFinishedSubject.send(())
        }
      }
  }
  
  private func countdownText(from seconds: Int) -> String {
    if seconds <= 0 {
      return "0초"
    }
    let d = seconds / 86_400
    let h = (seconds % 86_400) / 3_600
    let m = (seconds % 3_600) / 60
    let s = seconds % 60
    
    var parts: [String] = []
    if d > 0 {
      parts.append("\(d)일")
    }
    if h > 0 || d > 0 {
      parts.append("\(h)시간")
    }
    if m > 0 || h > 0 || d > 0 {
      parts.append("\(m)분")
    }
    parts.append("\(s)초")
    return parts.joined(separator: " ")
  }

  private func makeTextStackView(title: String, descriptionLabel: UILabel) -> UIStackView {
    let textStackView = UIStackView().then {
      $0.axis = .horizontal
      $0.alignment = .fill
      $0.distribution = .fill
    }
    textStackView.snp.makeConstraints { make in
      make.height.equalTo(21)
    }
    let titleLabel = UILabel().then {
      $0.style = Typography.Body_14_M
      $0.textColor = STColors.gray3.color
      $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    titleLabel.styledText = title
    textStackView.addArrangedSubview(titleLabel)
    textStackView.addArrangedSubview(descriptionLabel)
    return textStackView
  }
}

@available(iOS 17.0, *)
#Preview {
  let cellModel = NumberRecommendationCollectionViewCellModel(
    roundText: "1181회",
    title: "콩떡님을 위한 로또 번호 추천",
    numbers: [9, 11, 18, 24, 33, 42]
  )
  let cell = NumberRecommendationCollectionViewCell()
  cell.update(with: cellModel)
  cell.snp.makeConstraints { make in
    make.height.equalTo(251)
  }
  return cell
}
