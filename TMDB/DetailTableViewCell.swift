//
//  DetailTableViewCell.swift
//  TMDB
//
//  Created by t2023-m0032 on 6/25/24.
//

import UIKit
import SnapKit

class DetailTableViewCell: UITableViewCell {
    static let id = "DetailTableViewCell"
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    static func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        //let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: 110, height: 160)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return layout
    }
    
    let similarLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        contentView.addSubview(collectionView)
        contentView.addSubview(similarLabel)

        similarLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(10)
        }
        similarLabel.font = .boldSystemFont(ofSize: 20)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(similarLabel.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
