//
//  LibViewController.swift
//  CommonLayer
//
//  Created by 최재혁 on 8/3/25.
//

import Foundation
import UIKit

public final class LibViewController: UIViewController {
  // MARK: - UI Components

  private lazy var libLabel: UILabel = UILabel().then {
    $0.text = "Lib 화면입니다."
    $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    $0.textColor = .black
    $0.textAlignment = .center
  }

  // MARK: - View Lifecycle

  public override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  // MARK: - Setup Methods

  private func setupView() {
    view.backgroundColor = .white
    view.addSubview(libLabel)

    libLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}
