//
//  HistoryWebViewController.swift
//  History
//
//  Created by ttozzi on 8/17/25.
//

import Base
import DesignSystem
import SnapKit
import UIKit
import WebKit

public final class HistoryWebViewController: BaseViewController {

  private lazy var webView = WKWebView().then {
    $0.navigationDelegate = self
  }
  private let viewModel: HistoryWebViewModel

  public init(viewModel: HistoryWebViewModel) {
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

  private func setupUI() {
    setNavigationBarHidden(true)
    view.backgroundColor = STColors.primary9.color
    webView.backgroundColor = STColors.primary9.color

    view.addSubview(webView)
    webView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }

  private func setupBinding() {
    viewModel.output.loadURL
      .receive(on: DispatchQueue.main)
      .sink { [weak self] request in
        self?.showLoading()
        self?.webView.load(request)
      }
      .store(in: &cancellables)

    viewModel.output.needsRecovery
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] needsRecovery in
        guard let self = self else { return }
        guard needsRecovery else { return }
        if UIApplication.shared.applicationState == .active {
          self.recoverIfNeeded()
        }
      }
      .store(in: &cancellables)

    NotificationCenter.default.publisher(
      for: UIApplication.willEnterForegroundNotification
    )
    .receive(on: DispatchQueue.main)
    .sink { [weak self] _ in
      self?.recoverIfNeeded()
    }
    .store(in: &cancellables)
  }

  private func recoverIfNeeded() {
    guard viewModel.output.needsRecovery.value else { return }
    showLoading()
    webView.reload()
    viewModel.send(input: .recovered)
  }
}

extension HistoryWebViewController: WKNavigationDelegate {
  public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    // TODO: 뷰모델로 분리
    hideLoading()
  }

  public func webView(
    _ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error
  ) {
    // TODO: 뷰모델로 분리
    hideLoading()
    // TODO: 에러 처리
    print(error)
  }

  public func webView(
    _ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!,
    withError error: any Error
  ) {
    // TODO: 뷰모델로 분리
    hideLoading()
    // TODO: 에러 처리
    print(error)
  }

  public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
    viewModel.send(input: .webContentProcessDidTerminate)
  }
}
