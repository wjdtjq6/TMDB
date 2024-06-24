//
//  SearchViewController.swift
//  TMDB
//
//  Created by t2023-m0032 on 6/11/24.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

struct Search: Decodable {
    let page: Int
    var results: [Result]
    let total_pages: Int
    let total_results: Int
}
struct Result: Decodable {
    let poster_path: String?
    let id: Int
    let original_title: String
}

class SearchViewController: UIViewController {
    
    let searchBar = UISearchBar()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    var list = Search.init(page: 1, results: [], total_pages: 10, total_results: 100)
    var page = 1
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 40
        layout.itemSize = CGSize(width: width/3, height: width/2)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.prefetchDataSource = self
        
        view.addSubview(collectionView)
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp_bottomMargin).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        view.backgroundColor = .systemBackground
        navigationItem.title = "영화 검색"
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        searchBar.placeholder = "영화 제목을 검색해보세요."
        //callRequest(query: "marvel")
    }
    func callRequest(query: String) {
        let url = "https://api.themoviedb.org/3/search/movie?query=\(query)&page=\(page)"//&size=10"
        let header: HTTPHeaders = [
            "accept" : "KakaoAK application/json",
            "Authorization" : "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NjI1ZGY1ZmMwZjBkMTAxZjI1Y2MzY2NkNjUzMWQ5NSIsInN1YiI6IjY2NjA2ODFiYzdjMTZiNjhhZjU3NTNiZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Heb6kxmB0LJQlXNCCMLH-fBnWnjDM-UPHxwFm2YsE7k"
        ]
        AF.request(url,headers: header).responseDecodable(of: Search.self) { response in
            /*
             페이지네이션
             1.스크롤이 끝날 쯤에 다음 페이지를 요청(page += 1 후 callRequest)
             2.이전 내용은 어떻게 확인하지?(self.list = value => append로 해결)
             3.다른 검색어를 입력할 때는? (ex. page == 1)
              - 교체가. 아니라 append로 되고 있음
              - 1페이지부터 검색되도록 설정
              - 상단으로 스크롤을 이동
             4.배열을 언제 제거해줄지?
             5.마지막 페이지 처리
             */
            switch response.result {
            case .success(let value):

                if self.page == 1 {
                    self.list.results = value.results
                }
                else {
                    self.list.results.append(contentsOf: value.results)
                }
                self.collectionView.reloadData()
                
                if self.page == 1 && !self.list.results.isEmpty {
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    

}
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.originalTitle = list.results[indexPath.item].original_title
        vc.id = list.results[indexPath.item].id
        navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for i in indexPaths {
            if i.row == list.results.count-2 && page != list.total_pages {
                page += 1
                callRequest(query: searchBar.text!)
                print("1111111")
            }
        }
        
    }
    

}
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        page = 1
        callRequest(query: searchBar.text!)
    }
}
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.results.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        
        if list.results[indexPath.item].poster_path != nil {
            let url = URL(string: "https://image.tmdb.org/t/p/w500"+list.results[indexPath.item].poster_path!)
                cell.imageView.kf.setImage(with: url)
        } else {
            cell.imageView.image = .none
        }
        return cell
    }
    
    
}
