//
//  TempViewController.swift
//  TMDB
//
//  Created by t2023-m0032 on 6/25/24.
//
import UIKit
import SnapKit

private enum Nasa: String, CaseIterable {
    static let baseURL = "https://apod.nasa.gov/apod/image/"
    
    case one = "2308/sombrero_spitzer_3000.jpg"
    case two = "2212/NGC1365-CDK24-CDK17.jpg"
    case three = "2307/M64Hubble.jpg"
    case four = "2306/BeyondEarth_Unknown_3000.jpg"
    case five = "2307/NGC6559_Block_1311.jpg"
    case six = "2304/OlympusMons_MarsExpress_6000.jpg"
    case seven = "2305/pia23122c-16.jpg"
    case eight = "2308/SunMonster_Wenz_960.jpg"
    case nine = "2307/AldrinVisor_Apollo11_4096.jpg"
     
    static var photo: URL {
        return URL(string: Nasa.baseURL + Nasa.allCases.randomElement()!.rawValue)!
    }
}
final class TempViewController: UIViewController {
    let imageView = UIImageView()
    let requestButton = UIButton()
    let progressLabel = UILabel()
    var total: Double = 0
    var buffer: Data? {
        didSet {
            let result = Double(buffer?.count ?? 0) / total
            progressLabel.text = "\((result*100).rounded()) / 100"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarachy()
        configureLayout()
        configureUI()
    }
    func configureHierarachy() {
        view.addSubview(requestButton)
        view.addSubview(progressLabel)
        view.addSubview(imageView)
    }
    func configureLayout() {
        requestButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(requestButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    func configureUI() {
        requestButton.backgroundColor = .link
        requestButton.addTarget(self, action: #selector(requestButtonClicked), for: .touchUpInside)
        progressLabel.backgroundColor = .red
        imageView.backgroundColor = .brown
    }
    @objc func requestButtonClicked() {
        requestButton.isEnabled = false
        self.callRequest()
        self.buffer = Data()//buffer가 nil이라 작동안돼서 초기화
    }
    func callRequest() {
        let request = URLRequest(url: Nasa.photo)
        URLSession(configuration: .default, delegate: self, delegateQueue: .main).dataTask(with: request).resume()
    }
}
extension TempViewController: URLSessionDataDelegate {
    //최초로 응답받을 때 호출됨
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
        if let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) {
            //총 데이터 양 얻기
            let contentLength = response.value(forHTTPHeaderField: "Content-Length")!
            total = Double(contentLength)!
            return .allow
        }
        else {
            print(requestButton.isEnabled)
            requestButton.isEnabled = true
            return .cancel
        }
    }
    //서버에서 데이터를 받을 때마다 반복적으로 호출됨
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer!.append(data)// => buffer가 nil이라 작동이 안됨
        print(#function)
    }
    //응답이 완료될 때 호출됨
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        if let error {
            print(error)
            imageView.image = UIImage(systemName: "star.fill")
        } else {
            guard let buffer else {
                print("buffer nil")
                return
            }
            let image = UIImage(data: buffer)
            imageView.image = image
            requestButton.isEnabled = true
        }

    }
}
//1.enable //hidden
//2.e\그 동안 클리강ㄴ되게 설정
//3.끝났을때 풀어주기

//thread
