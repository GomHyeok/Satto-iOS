//
//  PushSettingImageCollectionViewCell.swift
//  Setting
//
//  Created by ttozzi on 7/31/25.
//

import DesignSystem
import SnapKit
import Then
import UIKit

struct PushSettingImageCollectionViewCellModel: PushSettingCellModel {
  let image: UIImage? // TODO: 이미지 리소스 확인
}

final class PushSettingImageCollectionViewCell: UICollectionViewCell {
  
  private lazy var imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.backgroundColor = STColors.primary9.color
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.backgroundColor = .clear
    contentView.layer.cornerRadius = 6
    contentView.clipsToBounds = true
    
    contentView.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.height.equalTo(159) // TODO: 임시 코드
    }
  }
  
  func update(with cellModel: PushSettingImageCollectionViewCellModel) {
    imageView.image = cellModel.image
  }
}
