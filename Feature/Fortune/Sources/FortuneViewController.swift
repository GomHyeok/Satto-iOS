//
//  FortuneViewController.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/8/25.
//

import UIKit
import DesignSystem
import Combine

import Then

enum FortuneSection {
    case fortune
    case overall
    case thumbnail
    case detail
}

final class FortuneViewController : UIViewController {
    //private lazy var collectionView : UICollectionView
    private lazy var sattoImage : UIImageView = UIImageView().then {
        $0.image = STImages.sattoLogo.image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinding()
        setupHierarchy()
        setupUI()
    }
}

// MARK: func
extension FortuneViewController {
    
}

// MARK: SetupFunc
extension FortuneViewController {
    private func setupHierarchy() {
        
    }
    
    private func setupUI() {
        
    }
    
    private func setupBinding() {
        
    }
}

//@available(iOS 17.0, *)
//#Preview {
//    HomeViewController()
//}
