//
//  DetailViewController.swift
//  TMDB
//
//  Created by t2023-m0032 on 6/24/24.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

struct Similar:Decodable {
    let page: Int
    let results: [SimilarResult]
}
struct SimilarResult:Decodable {
    let poster_path: String
}

class DetailViewController: UIViewController {
    let titleLable = UILabel()
    let similarLabel = UILabel()
    lazy var collectionView1 = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let recommendLabel = UILabel()
    lazy var collectionView2 = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    var originalTitle = ""
    var id = 0
    var posterList1:[SimilarResult] = []
    var posterList2:[SimilarResult] = []
    
    let tableView = UITableView()
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        //let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: 110, height: 160)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return layout
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        callRequest(parameter: "/similar") { value in
            self.posterList1 = value
            self.collectionView1.reloadData()
        }
        callRequest(parameter: "/recommendation") { value in
            self.posterList2 = value
            self.collectionView2.reloadData()
        }
    }
    func configureHierarchy() {
        view.addSubview(titleLable)
        view.addSubview(similarLabel)
        view.addSubview(collectionView1)
        collectionView1.delegate = self
        collectionView1.dataSource = self
        collectionView1.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        view.addSubview(recommendLabel)
        view.addSubview(collectionView2)
        collectionView2.delegate = self
        collectionView2.dataSource = self
        collectionView2.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.id)
    }
    func configureLayout() {
        titleLable.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        similarLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        collectionView1.snp.makeConstraints { make in
            make.top.equalTo(similarLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(170)
        }
        recommendLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView1.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        collectionView2.snp.makeConstraints { make in
            make.top.equalTo(recommendLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(170)
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    func configureUI() {
        view.backgroundColor = .black
        titleLable.text = originalTitle
        titleLable.font = .boldSystemFont(ofSize: 30)
        similarLabel.text = "비슷한 영화"
        similarLabel.font = .boldSystemFont(ofSize: 20)
        recommendLabel.text = "추천 영화"
        recommendLabel.font = .boldSystemFont(ofSize: 20)
    }
    func callRequest(parameter: String, completion: @escaping ([SimilarResult]) -> Void ) {
        let url = "https://api.themoviedb.org/3/movie/\(id)"
        let headers: HTTPHeaders = [
            "Authorization":"Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NjI1ZGY1ZmMwZjBkMTAxZjI1Y2MzY2NkNjUzMWQ5NSIsIm5iZiI6MTcxOTIyMDg3Ni45NjUwMTksInN1YiI6IjY2NjA2ODFiYzdjMTZiNjhhZjU3NTNiZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.CE3TpPMcseKddPWbAAiWRv7s_rlWOZDTxsClf-UWOUc",
            "accept":"application/json"
        ]
        AF.request(url+parameter,headers: headers).responseDecodable(of: Similar.self) { response in
            switch response.result {
            case .success(let value):
                print(value)
                completion(value.results)
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
}
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.id, for: indexPath) as! DetailTableViewCell
        cell.backgroundColor = .purple
        return cell
    }
    
    
}
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            posterList1.count
        }
        else {
            posterList2.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        if collectionView == collectionView1 {
            let url = URL(string: "https://image.tmdb.org/t/p/w500"+posterList1[indexPath.item].poster_path)
            cell.imageView.kf.setImage(with: url)
        }
        else {
            let url = URL(string: "https://image.tmdb.org/t/p/w500"+posterList2[indexPath.item].poster_path)
            cell.imageView.kf.setImage(with: url)
        }
        return cell
    }
}
