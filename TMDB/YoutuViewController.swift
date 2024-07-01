//
//  YoutuViewController.swift
//  TMDB
//
//  Created by t2023-m0032 on 7/1/24.
//

import UIKit
import WebKit
import Toast

final class YoutuViewController: UIViewController {
    private let webView = WKWebView()
    var id = 0
    private var key = [YoutubeKeys]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .systemBackground
        //webView.backgroundColor = .systemBackground
        configureHierarchy()
        configureLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TMDBAPI.shared.request(api: .creditRecommendSimilarVideos(id: id, endPoint: "videos"), model: Youtube.self) { success, fail in
            if let fail {
                print(fail)
            } else {
                guard let success else { return }
                self.key = success.results
                print(self.key)
                self.configureUI()
            }
        }
    }
    private func configureHierarchy() {
        view.addSubview(webView)
        webView.navigationDelegate = self
    }
    private func configureLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func configureUI() {
        if key.isEmpty {
            self.view.makeToast("연결된 유튜브가 존재하지 않아요")        }
        else {
            let url = URL(string: "https://www.youtube.com/watch?v=" + key.randomElement()!.key)
            let request = URLRequest(url: url!)
            webView.load(request)
        }
    }
}
extension YoutuViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        self.view.makeToast("네트워크 연결이 끊어졌습니다. 인터넷 연결을 확인해주세요.")
    }
    //webview white screen problem solving
//    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
//        self.webView.reload()
//    }
}
