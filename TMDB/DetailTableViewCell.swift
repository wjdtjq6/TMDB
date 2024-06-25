//
//  DetailTableViewCell.swift
//  TMDB
//
//  Created by t2023-m0032 on 6/25/24.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    static let id = "DetailTableViewCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    override func awakeFromNib() {
//        super.awakeFromNib()
//        contentView.backgroundColor = .link
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
