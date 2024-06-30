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

class SearchViewController: UIViewController {
    
    let searchBar = UISearchBar()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    var searchList = Search.init(page: 1, results: [], total_pages: 10, total_results: 10)
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
    }

}
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.originalTitle = searchList.results[indexPath.item].original_title
        //TMDBAPI.id = list.results[indexPath.item].id
        vc.id = searchList.results[indexPath.item].id
        navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for i in indexPaths {
            if i.row == searchList.results.count-2 && page != searchList.total_pages {
                page += 1
                TMDBAPI.shared.request(api: .search(query: searchBar.text!, page: page, size: 10), model: Search.self) { value in
                    if self.page == 1 {
                        self.searchList.results = value.results
                    }
                    else {
                        self.searchList.results.append(contentsOf: value.results)
                    }
                    self.collectionView.reloadData()
                
                    if self.page == 1 && !self.searchList.results.isEmpty {
                        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                    }
                }
            }
        }
        
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        page = 1
        TMDBAPI.shared.request(api: .search(query: searchBar.text!, page: page, size: 10), model: Search.self) { value in
            if self.page == 1 {
                self.searchList.results = value.results
            }
            else {
                self.searchList.results.append(contentsOf: value.results)
            }
            self.collectionView.reloadData()
        
            if self.page == 1 && !self.searchList.results.isEmpty {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }        }
    }
}
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchList.results.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        
        if searchList.results[indexPath.item].poster_path != nil {
            let url = URL(string: "https://image.tmdb.org/t/p/w500"+searchList.results[indexPath.item].poster_path!)
                cell.imageView.kf.setImage(with: url)
        } else {
            cell.imageView.image = .none
        }
        return cell
    }
    
    
}
