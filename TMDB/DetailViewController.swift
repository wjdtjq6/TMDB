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
    var posterList1:[SimilarResult] = []
    var posterList2:[SimilarResult] = []
    var posterLists:[[SimilarResult]] = [[],[]]
    let tableView = UITableView()
    let textList = ["비슷한 영화","추천 영화"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
        group.enter() //+1
        DispatchQueue.global().async(group: group) {
            TMDBAPI.shared.callRequest(parameter: "/similar") { success,fail in
                if let fail = fail {
                    print(fail)
                }else {
                    guard let success = success else { return }
                    self.posterLists[0] = success
                }
                print("11111")
                group.leave() //-1
            }
        }
        
        group.enter() //+1
        DispatchQueue.global().async(group: group) {
            TMDBAPI.shared.callRequest(parameter: "/recommendations") { movie, error in
                if let error = error {
                    print(error)
                }else {
                    guard let movie = movie else { return }
                    self.posterLists[1] = movie
                }
                print("22222")
                group.leave() //-1            }
            }
        }
        group.notify(queue: .main) {
            self.tableView.reloadData()
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
