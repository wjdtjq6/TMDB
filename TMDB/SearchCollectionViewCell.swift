//
//  SearchCollectionViewCell.swift
//  TMDB
//
//  Created by t2023-m0032 on 6/11/24.
//

import UIKit
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    static var identifier = "SearchCollectionViewCell"
    
    let imageView = UIImageView()
    
    required init?(coder: NSCoder) {
        fatalError("울랄라")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
}
