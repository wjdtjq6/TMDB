//
//  CreditViewController.swift
//  TMDB
//
//  Created by t2023-m0032 on 6/29/24.
//

import UIKit
import SnapKit
import Kingfisher

final class CreditViewController: UIViewController {
    private let bigImage = UIImageView()
    private let titleLabel = UILabel()
    private let smallImage = UIImageView()
    private let tableView = UITableView()
    var Movietitle = ""
    var id = 0
    var overview = ""
    var movieCreditList = [Cast]()
    var backImage = ""
    var posterImage = ""
    override func viewDidLoad() {
        navigationItem.title = "출연/제작"
        TMDBAPI.shared.request(api: .creditRecommendSimilarVideos(id: id, endPoint: "credits"), model: MovieCredit.self) { success, fail in
            if let fail {
                print(fail)
            } else {
                guard let success else { return }
                self.movieCreditList = success.cast
                self.tableView.reloadData()
            }
        }
        configureHierarchy()
        configurerLayout()
        configureUI()
    }
    private func configureHierarchy() {
        view.addSubview(bigImage)
        view.addSubview(titleLabel)
        view.addSubview(smallImage)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CreditTableViewCell.self, forCellReuseIdentifier: CreditTableViewCell.id)
    }
    private func configurerLayout() {
        bigImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(20)
        }
        smallImage.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.width.equalTo(90)
            make.bottom.equalTo(bigImage).inset(10)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(bigImage.snp.bottom)//.offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.bottom.equalTo(view)
        }
    }
    private func configureUI() {
        view.backgroundColor = .systemBackground
        let url1 = URL(string: "https://image.tmdb.org/t/p/w500"+backImage)
        bigImage.kf.setImage(with: url1)
        //bigImage.alpha = 0.5 view를 추가해서 백그라운드 블랙으로!!
        titleLabel.text = Movietitle
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 25)
        let url2 = URL(string: "https://image.tmdb.org/t/p/w500"+posterImage)
        smallImage.kf.setImage(with: url2)
    }
}
extension CreditViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            UITableView.automaticDimension
        } else {
            80
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "OverView"
        }
        else {
            return "Cast"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            1
        } else {
            movieCreditList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreditTableViewCell.id, for: indexPath) as! CreditTableViewCell
        // 셀의 UI 요소 초기화
            cell.overviewLable.text = nil
            cell.expandButton.setImage(nil, for: .normal)
            cell.castImage.image = nil
            cell.castImage.backgroundColor = .clear
            cell.castTitleLabel.text = nil
            cell.castSubLabel.text = nil
        
        if indexPath.section == 0 {
            cell.overviewLable.text = overview
            cell.expandButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
        else {
            if movieCreditList[indexPath.row].profile_path != nil {
                let url = URL(string: "https://image.tmdb.org/t/p/w500"+movieCreditList[indexPath.row].profile_path!)
                cell.castImage.kf.setImage(with: url)
            } else {
                cell.castImage.backgroundColor = .clear
            }
            cell.castTitleLabel.text = movieCreditList[indexPath.row].original_name
            cell.castSubLabel.text = /*movieCreditList[indexPath.row].name+" / "+*/movieCreditList[indexPath.row].character
        }
        return cell
    }
    
    
}
