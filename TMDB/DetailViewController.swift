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

class DetailViewController: UIViewController {
    let titleLable = UILabel()
    var originalTitle = ""
    var posterList1:[SimilarOrRecommendResult] = []
    var posterList2:[SimilarOrRecommendResult] = []
    var posterLists:[[SimilarOrRecommendResult]] = [[],[]]
    let tableView = UITableView()
    let textList = ["비슷한 영화","추천 영화"]
    var id = 0
    var searchResultList = [Result]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
        
        group.enter() //+1
        DispatchQueue.global().async(group: group) {
            TMDBAPI.shared.request(api: .detail(id: self.id), model: SimilarOrRecommend.self) { value in
                self.posterLists[0] = value.results
            }
//            TMDBAPI.shared.callRequest(parameter: "/similar") { success,fail in
//                if let fail = fail {//if fail == nil { //fail이 nil이면 실패
//                    print(fail)
//                    print(1)
//                }
//                else { //아니면 성공
//                    print(2)
//                    guard let success = success else { //success가 닐이면 실패 => 3
//                        print(3)
//                        return }
//                    print(4)//success가 닐이 아니면 = 성공
//                    self.posterLists[0] = success
//                }
//                print(5)
//                group.leave() //-1
//                
//            }
        }
        
        group.enter() //+1
        DispatchQueue.global().async(group: group) {
//            TMDBAPI.shared.callRequest(parameter: "/recommendations") { movie, error in
//                guard let movie = movie else {/*movie가 nil이면 안으로*/return }
//                self.posterLists[1] = movie//emovie가 nil이 아니면
//                group.leave() //-1
//            }
        }
        
        group.notify(queue: .main) { // 0dl ehlaus
            self.tableView.reloadData()
            print(self.posterLists)
            print(self.posterLists[0])
            print("333333")
        }
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    func configureHierarchy() {
        view.addSubview(titleLable)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 200
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.id)
    }
    func configureLayout() {
        titleLable.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view)
        }
    }
    func configureUI() {
        titleLable.text = originalTitle
        titleLable.font = .boldSystemFont(ofSize: 30)
    }
}
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posterLists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.id, for: indexPath) as! DetailTableViewCell
        cell.collectionView.dataSource = self
        cell.collectionView.delegate = self
        cell.collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.id)
        
        cell.similarLabel.text = textList[indexPath.row]
        cell.collectionView.tag = indexPath.row
        cell.collectionView.reloadData()
        return cell
    }
    
    
}
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posterLists[collectionView.tag].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.id, for: indexPath) as! DetailCollectionViewCell
        let data = posterLists[collectionView.tag][indexPath.item].poster_path        
        let url = URL(string: "https://image.tmdb.org/t/p/w500"+data)
        cell.imageView.kf.setImage(with: url)
        return cell
    }
}
