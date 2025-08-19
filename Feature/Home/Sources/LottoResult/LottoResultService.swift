//
//  LottoResultService.swift
//  Home
//
//  Created by ttozzi on 8/19/25.
//

import Auth
import DIInjector
import Extension
import Foundation
import NetworkCore

struct LottoResultService {

  struct Response {
    let resultInfo: LottoResultInfoModel
    let sattoMessage: SattoMessageModel
    let resultNumber: LottoResultNumberModel
  }

  @Injected private var userDataManager: UserDataManager
  @Injected private var networkProvider: NetworkProvider

  func fetch(round: Int) async throws -> Response {
    let target = HomeTarget.CheckLottoResult(userID: userDataManager.userID, round: round)
    let lottoResult = try await networkProvider.request(target: target)

    let rankTitle =
      if let rank = lottoResult.rank {
        "\(rank)등 당첨!"
      } else {
        "도전 실패!"
      }
    let prizeDescription =
      if let prizeAmount = lottoResult.prizeAmount {
        "\(prizeAmount.formatted())원"
      } else {
        "다음 기회에..."
      }
    let resultInfo = LottoResultInfoModel(
      isWinner: lottoResult.rank != nil,
      roundText: "\(lottoResult.round)회",
      title: rankTitle,
      desciprtion: prizeDescription
    )

    let sattoMessage = SattoMessageModel(
      title: "사또의 한마디...",
      message: "축하드리네!\n이번 행운의 주인공은 그대라네."
    )

    let rankText =
      if let rank = lottoResult.rank {
        "\(rank)등"
      } else {
        "꽝"
      }
    let resultNumber = LottoResultNumberModel(
      rankText: rankText,
      winningNumbers: lottoResult.drawNumbers,
      bonusNumber: lottoResult.bonusNumber,
      recommendedNumbers: lottoResult.recommendedNumbers
    )

    return Response(
      resultInfo: resultInfo,
      sattoMessage: sattoMessage,
      resultNumber: resultNumber
    )
  }
}
