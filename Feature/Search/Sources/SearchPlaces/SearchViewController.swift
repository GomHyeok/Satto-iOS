//
//  SearchViewController.swift
//  FeatureLayer
//
//  Created by 최재혁 on 12/28/25.
//

import UIKit
import Foundation
import Combine

import DesignSystem
import Base

public final class SearchViewController: BaseViewController {
  
  private let viewModel: SearchViewModel
  
  // TODO: SearchView, CollectionViewCell, CollectionView, EmptyView로 화면 구성
  
  public init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
    viewModel.send(input: .viewDidLoad)
  }
  
  private func createLayout() -> UICollectionViewCompositionalLayout {
    
  }
}

extension SearchViewController {
  private func setupUI() {
    view.backgroundColor = .systemBackground
  }
  
  private func setupBinding() {
    
  }
}

#if targetEnvironment(simulator)
@available(iOS 17.0, *)
#Preview {
  let viewModel = SearchViewModel()
  let searchViewController = SearchViewController(viewModel: viewModel)
  
  return searchViewController
}
#endif
