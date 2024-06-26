//
//  DetailCollectionViewCell.swift
//  TMDB
//
//  Created by t2023-m0032 on 6/24/24.
//

import UIKit
import SnapKit

class DetailCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    static let id = "DetailCollectionViewCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
