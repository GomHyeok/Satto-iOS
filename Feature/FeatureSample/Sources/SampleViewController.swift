//
//  SampleViewController.swift
//  FeatureLayer
//
//  Created by 최재혁 on 1/26/26.
//

import UIKit
import Search

final class SampleViewController: UIViewController {

  private var features: [SampleFeature] = [
    SampleFeature(
      title: "Search Feature",
      viewControllerProvider: { SearchViewController(viewModel: SearchViewModel()) }
    ),
    SampleFeature(title: "Test Feature", viewControllerProvider: {UIViewController()})
  ]

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)

    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .systemBackground
    cv.register(SampleFeatureCell.self,
                forCellWithReuseIdentifier: SampleFeatureCell.identifier)
    cv.dataSource = self
    cv.delegate = self
    return cv
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    //self.navigationController?.navigationBar.isHidden = true
    
    view.backgroundColor = .systemBackground
    setupLayout()
  }

  private func setupLayout() {
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

extension SampleViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    features.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: SampleFeatureCell.identifier,
      for: indexPath
    ) as? SampleFeatureCell else {
      return UICollectionViewCell()
    }

    cell.configure(title: features[indexPath.item].title)
    return cell
  }
}

extension SampleViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {

    let vc = features[indexPath.item].viewControllerProvider()
    
    navigationController?.pushViewController(vc, animated: true)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {

    let width = collectionView.bounds.width - 32
    return CGSize(width: width, height: 40)
  }
}


