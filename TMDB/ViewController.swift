//
//  ViewController.swift
//  TMDB
//
//  Created by t2023-m0032 on 6/10/24.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

struct Movie_Week: Decodable {
    let results: [Results]
}
struct Results: Decodable {
    let overview: String
    let poster_path: String
    let title: String
    let release_date: String
    let vote_average: Double
    let genre_ids: [Int]
    let id: Int
}

//struct Datas {
//    let overview: String
//    let poster_path: String
//    let title: String
//    let release_date: String
//    let vote_average: Double
//}
//genre_ids때문에
struct Genre: Decodable {
    let genres: [GenreName]
}
struct GenreName: Decodable {
    let id: Int
    let name: String
}
//id(cast사람들 때문에)
//struct

class ViewController: UIViewController {
    
    let tableView = UITableView()
    
    var list: [Results] = [] {
        
        didSet {
            
            tableView.reloadData()
            
        }
        
    }
    let url = "https://api.themoviedb.org/3/trending/movie/week?api_key=7625df5fc0f0d101f25cc3ccd6531d95"
    
    var list2: [GenreName] = []
    let url2 = "https://api.themoviedb.org/3/genre/movie/list"
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        
        callRequest()
        callRequestGenre()
    }
    func callRequestGenre() {
        let header: HTTPHeaders = [
            "accept":"application/json",
            "Authorization":"Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NjI1ZGY1ZmMwZjBkMTAxZjI1Y2MzY2NkNjUzMWQ5NSIsInN1YiI6IjY2NjA2ODFiYzdjMTZiNjhhZjU3NTNiZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Heb6kxmB0LJQlXNCCMLH-fBnWnjDM-UPHxwFm2YsE7k"
        ]
        AF.request(url2,headers: header).responseDecodable(of: Genre.self) { response in
            
            switch response.result {
            case .success(let value):
                self.list2 = value.genres
                //print(self.list2)
                //self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    func callRequest() {
        AF.request(url,method: .get).responseDecodable(of: Movie_Week.self) { response in
            
            print(response.response?.statusCode ?? 0)
            
            switch response.result {
            case .success(let value):
                self.list = value.results
                //print(self.list)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    func configureHierarchy() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.register(TrendTableViewCell.self, forCellReuseIdentifier: "TrendTableViewCell")
        
        tableView.separatorStyle = .none
    }
    func configureLayout() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(leftBarButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(rightBarButtonClicked))
        
        let appearance = UINavigationBarAppearance()
        //appearance.configureWithOpaqueBackground()
        //appearance.shadowImage = UIImage()
        //navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }
        tableView.rowHeight = 400
    }
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    @objc func leftBarButtonClicked() {
        
    }
    @objc func rightBarButtonClicked() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrendTableViewCell", for: indexPath) as! TrendTableViewCell
        cell.dateLabel.text = list[indexPath.row].release_date
        
        var jimmy: String = ""
        for i in list[indexPath.row].genre_ids {
            for j in 0...18 {
                if i == list2[j].id {
                    jimmy = jimmy + list2[j].name + " "
                    print(jimmy, "222222")
                }
            }
        }
        cell.hashtagLabel.text = jimmy
        let url = URL(string: "https://image.tmdb.org/t/p/w500"+list[indexPath.row].poster_path)
        cell.uiimageView.kf.setImage(with: url)
        cell.clipButton.setImage(UIImage(systemName: "paperclip.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35)), for: .normal)
        cell.gradeNumberLabel.text = String(format: "%.1f",list[indexPath.row].vote_average)//"3.3"
        cell.titleLabel.text = list[indexPath.row].title//"Alice in Borderland"
        cell.castLabel.text = list[indexPath.row].overview//"qmfqkldalnsdoqwbdqi"
        
        return cell
    }
    
    
}
