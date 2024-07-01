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

final class ViewController: UIViewController {
    
    private let tableView = UITableView()
    private var trendingMovieList: [TrendingMovieResults] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var genreList: [GenreName] = []
    //let url = "https://api.themoviedb.org/3/trending/movie/week?api_key=7625df5fc0f0d101f25cc3ccd6531d95"
    //let url2 = "https://api.themoviedb.org/3/genre/movie/list"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* 오잉 1111밖에 프린트가 안됨 */
        //callRequest()
        print("1111")
        TMDBAPI.shared.request(api: .trendingMovie, model: TrendingMovie.self) { success,fail  in
            if let fail {
                print(fail)
            }
            else {
                guard let success else { return }
                self.trendingMovieList = success.results
            }
        }
        print("2222")
        //callRequestGenre()
        TMDBAPI.shared.request(api: .trendingMovieGenre, model: Genre.self) { success, fail in
            if let fail {
                print(fail)
            }
            else {
                guard let success else { return }
                self.genreList = success.genres
            }
        }
        print("33333")
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    private func configureHierarchy() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.register(TrendTableViewCell.self, forCellReuseIdentifier: "TrendTableViewCell")
        tableView.separatorStyle = .none
    }
    private func configureLayout() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(leftBarButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(rightBarButtonClicked))
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        tableView.rowHeight = 400
    }
    private func configureUI() {
        //view.backgroundColor = .systemBackground
    }
    //temp
    @objc private func leftBarButtonClicked() {
        let vc = TempViewController()
        present(vc, animated: true)
    }
    @objc private func rightBarButtonClicked() {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CreditViewController()
        vc.Movietitle = trendingMovieList[indexPath.row].title
        vc.id = trendingMovieList[indexPath.row].id
        vc.overview = trendingMovieList[indexPath.row].overview
        vc.backImage = trendingMovieList[indexPath.row].backdrop_path
        vc.posterImage = trendingMovieList[indexPath.row].poster_path
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trendingMovieList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrendTableViewCell", for: indexPath) as! TrendTableViewCell
        cell.dateLabel.text = trendingMovieList[indexPath.row].release_date
        
        var jimmy: String = ""
        for i in trendingMovieList[indexPath.row].genre_ids {
            for j in 0..<genreList.count  {//0...18
                if i == genreList[j].id {
                    jimmy = jimmy + genreList[j].name + " "
                }
            }
        }
        cell.hashtagLabel.text = jimmy
        let url = URL(string: "https://image.tmdb.org/t/p/w500"+trendingMovieList[indexPath.row].poster_path)
        cell.uiimageView.kf.setImage(with: url)
        cell.clipButton.setImage(UIImage(systemName: "paperclip.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35)), for: .normal)
        cell.gradeNumberLabel.text = String(format: "%.1f",trendingMovieList[indexPath.row].vote_average)//"3.3"
        cell.titleLabel.text = trendingMovieList[indexPath.row].title//"Alice in Borderland"
        cell.castLabel.text = trendingMovieList[indexPath.row].overview//"qmfqkldalnsdoqwbdqi"
        
        return cell
    }
    
    
}
