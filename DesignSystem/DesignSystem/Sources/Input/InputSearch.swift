//
//  InputSearch.swift
//  DesignSystemLayer
//
//  Created by 최재혁 on 12/30/25.
//

import Then
import UIKit

public final class InputSearch : UIView {
  
  public override init(frame : CGRect) {
    super.init(frame : frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  private func setupUI() {
    
  }
  
  private func update() {
    
  }
}

extension InputSearch {
  
}

#if targetEnvironment(simulator)

@available(iOS 17.0, *)
#Preview {
  let inputSearch = InputSearch()
  
  return inputSearch
}

#endif
