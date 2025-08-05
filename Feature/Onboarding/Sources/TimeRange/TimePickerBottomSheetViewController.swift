//
//  TimePickerBottomSheetViewController.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/27/25.
//

import DesignSystem
import SnapKit
import Then
import UIKit

// MARK: - TimePickerBottomSheetDelegate
protocol TimePickerBottomSheetDelegate: AnyObject {
  func timePickerBottomSheet(
    _ controller: TimePickerBottomSheetViewController, didSelectTimeRange timeRange: String?)
  func timePickerBottomSheetDidCancel(_ controller: TimePickerBottomSheetViewController)
}

final class TimePickerBottomSheetViewController: UIViewController {

  weak var delegate: TimePickerBottomSheetDelegate?

  private let timeRanges = [
    "23:00 ~ 00:59", "01:00 ~ 02:59", "03:00 ~ 04:59",
    "05:00 ~ 06:59", "07:00 ~ 08:59", "09:00 ~ 10:59",
    "11:00 ~ 12:59", "13:00 ~ 14:59", "15:00 ~ 16:59",
    "17:00 ~ 18:59", "19:00 ~ 20:59", "21:00 ~ 22:59",
  ]
  private var selectedTimeRange: String?  // 선택된 시간 범위 저장

  private let containerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 16
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    $0.clipsToBounds = true
  }

  private let titleLabel = UILabel().then {
    var style = Typography.Body_18_B
    style.color = STColors.gray1.color
    $0.style = style
    $0.styledText = "태어난 시"
    $0.textAlignment = .center
  }

  private let closeButton = UIButton().then {
    $0.setImage(STImages.xMark.image, for: .normal)
  }

  // MARK: collectionView layout 설정 으로 기존 방식 사용
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 24 * 2), height: 44)

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.showsVerticalScrollIndicator = true
    collectionView.register(
      TimeRangeCell.self, forCellWithReuseIdentifier: TimeRangeCell.identifier)
    return collectionView
  }()

  private let selectDoneButton = UIButton().then {
    var style = Typography.Body_18_B
    style.color = STColors.white.color
    var styled = "선택 완료".set(style: style)
    $0.setAttributedTitle(styled, for: .normal)
    $0.backgroundColor = STColors.primary2.color
    $0.layer.cornerRadius = 8
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupGestures()
    setupDelegate()

    // 기본 선택값 설정: "23:00 ~ 00:59"
    if let defaultIndex = timeRanges.firstIndex(of: "23:00 ~ 00:59") {
      collectionView.selectItem(
        at: IndexPath(item: defaultIndex, section: 0), animated: false, scrollPosition: [])
      selectedTimeRange = timeRanges[defaultIndex]
    }
  }

  private func setupView() {
    view.backgroundColor = STColors.black.color.withAlphaComponent(0.5)
    view.addSubview(containerView)
    containerView.addSubview(titleLabel)
    containerView.addSubview(closeButton)
    containerView.addSubview(collectionView)
    containerView.addSubview(selectDoneButton)

    containerView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(view.snp.height).multipliedBy(0.5)  // 화면 높이의 60% 차지 (조정 가능)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(32)
      $0.leading.equalToSuperview().offset(24)
    }

    closeButton.snp.makeConstraints {
      $0.centerY.equalTo(titleLabel)
      $0.trailing.equalToSuperview().offset(-24)
      $0.width.height.equalTo(24)
    }
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(9)
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
      $0.bottom.equalTo(selectDoneButton.snp.top).offset(-33)
    }

    selectDoneButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
      $0.bottom.equalToSuperview().offset(-56)
      $0.height.equalTo(56)
    }
    selectDoneButton.addTarget(self, action: #selector(selectDoneButtonTapped), for: .touchUpInside)
  }

  private func setupGestures() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
    tapGesture.delegate = self
    view.addGestureRecognizer(tapGesture)
  }

  private func setupDelegate() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.allowsMultipleSelection = false
  }

  @objc private func handleBackgroundTap() {
    delegate?.timePickerBottomSheetDidCancel(self)
    dismiss(animated: true, completion: nil)
  }

  @objc private func closeButtonTapped() {
    delegate?.timePickerBottomSheetDidCancel(self)
    dismiss(animated: true, completion: nil)
  }

  @objc private func selectDoneButtonTapped() {
    delegate?.timePickerBottomSheet(self, didSelectTimeRange: selectedTimeRange)
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - UICollectionViewDataSource
extension TimePickerBottomSheetViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int
  {
    return timeRanges.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: TimeRangeCell.identifier, for: indexPath) as? TimeRangeCell
    else {
      return UICollectionViewCell()
    }
    cell.configure(with: timeRanges[indexPath.item])
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension TimePickerBottomSheetViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedTimeRange = timeRanges[indexPath.item]
  }

  // 선택 해제 방지 (항상 하나는 선택되어 있어야 함)
  func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath)
    -> Bool
  {
    // 현재 선택된 아이템이 하나뿐이라면 선택 해제를 막습니다.
    if collectionView.indexPathsForSelectedItems?.count == 1
      && collectionView.indexPathsForSelectedItems?.first == indexPath
    {
      return false
    }
    return true
  }
}

// MARK: - UIGestureRecognizerDelegate (바텀 시트 외부 탭 감지)
extension TimePickerBottomSheetViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch)
    -> Bool
  {
    return touch.view == self.view
  }
}
