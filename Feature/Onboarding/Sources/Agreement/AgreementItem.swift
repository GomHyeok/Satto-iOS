//
//  AgreementItem.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/30/25.
//

import Foundation

enum AgreementType {
  case all
  case service
  case privacy
  case age
}

struct AgreementItem {
  let id: AgreementType
  let title: String
  let isRequired: Bool  // 필수 약관 여부
  var isAgreed: Bool  // 동의 여부
  let hasDetail: Bool  // 상세 보기 유무 ('>' 아이콘 표시 여부)
}
