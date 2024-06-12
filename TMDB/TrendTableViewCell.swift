//
//  TrendTableViewCell.swift
//  TMDB
//
//  Created by t2023-m0032 on 6/10/24.
//

import UIKit
import SnapKit

class TrendTableViewCell: UITableViewCell {

    let dateLabel = UILabel()
    let hashtagLabel = UILabel()
    
    let uiView = UIView()
    let uiimageView = UIImageView()
    let clipButton = UIButton()
    let gradeLabel = UILabel()
    let gradeNumberLabel = UILabel()
    
    let titleLabel = UILabel()
    let castLabel = UILabel()
    let separator = UIView()
    let detailButton = UIButton(type: .system)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureHierarchy() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(hashtagLabel)
        
        contentView.addSubview(uiView)
        contentView.addSubview(uiimageView)
        contentView.addSubview(clipButton)
        contentView.addSubview(gradeLabel)
        contentView.addSubview(gradeNumberLabel)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(castLabel)
        contentView.addSubview(separator)
        contentView.addSubview(detailButton)
    }
    func configureLayout() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(15)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(15)
        }
        hashtagLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp_bottomMargin).offset(5)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(15)
        }
        uiView.snp.makeConstraints { make in
            make.top.equalTo(hashtagLabel.snp_bottomMargin).offset(20)
            make.leading.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
        uiimageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(uiView)//.inset(5)
            make.bottom.equalTo(uiView.snp_bottomMargin).inset(100)
        }
        clipButton.snp.makeConstraints { make in
            make.top.equalTo(uiView.snp_topMargin).offset(10)
            make.trailing.equalTo(uiView.snp.trailing).inset(15)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        gradeLabel.snp.makeConstraints { make in
            make.bottom.leading.equalTo(uiimageView).inset(15)
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
        gradeNumberLabel.snp.makeConstraints { make in
            make.bottom.equalTo(uiimageView).inset(15)
            make.leading.equalTo(gradeLabel.snp_trailingMargin).offset(8)
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(uiimageView.snp_bottomMargin).offset(25)
            make.leading.equalTo(uiView).inset(15)
        }
        castLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(10)
            make.leading.trailing.equalTo(uiView).inset(15)
        }
        separator.snp.makeConstraints { make in
            make.top.equalTo(castLabel.snp_bottomMargin).offset(20)
            make.leading.equalTo(uiView).inset(15)
            make.trailing.equalTo(uiView).inset(15)
            make.height.equalTo(1)
        }
        detailButton.snp.makeConstraints { make in
            make.top.equalTo(separator.snp_bottomMargin).offset(15)
            make.leading.equalTo(uiView).inset(15)
            make.trailing.equalTo(uiView).inset(15)
        }
    }
    func configureUI() {
        dateLabel.font = .boldSystemFont(ofSize: 14)
        dateLabel.textColor = .gray
        
        hashtagLabel.font = .boldSystemFont(ofSize: 18)
        
        uiView.layer.cornerRadius = 10
        uiView.layer.borderWidth = 1
        uiView.layer.borderColor = UIColor.white.cgColor
//        uiView.layer.shadowOffset = CGSize(width: 10, height: 10)
        uiView.layer.shadowColor = UIColor.black.cgColor
        uiView.layer.shadowOpacity = 1
        uiView.layer.shadowRadius = 2
        
        //uiimageView.image = UIImage(systemName: "star")
        //uiimageView.backgroundColor = .red
        uiimageView.layer.cornerRadius = 10
        uiimageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        uiimageView.clipsToBounds = true
        
        //clipButton.setImage(UIImage(systemName: "paperclip.circle.fill"), for: .normal)
//        clipButton.setImage(UIImage(systemName: "paperclip.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35)), for: .normal)
        clipButton.tintColor = .white
        
        gradeLabel.text = "평점"
        gradeLabel.textColor = .white
        gradeLabel.font = .systemFont(ofSize: 12)
        gradeLabel.textAlignment = .center
        gradeLabel.backgroundColor = .blue
        
//        gradeNumberLabel.text = "3.3"
        gradeNumberLabel.font = .systemFont(ofSize: 12)
        gradeNumberLabel.textAlignment = .center
        gradeNumberLabel.backgroundColor = .white
        
//        titleLabel.text = "Alice in Borderland"
        titleLabel.font = .boldSystemFont(ofSize: 17)
        
//        castLabel.text = "qmfqkldalnsdoqwbdqi"
        castLabel.font = .systemFont(ofSize: 14)
        castLabel.textColor = .gray
        
        separator.backgroundColor = .black
        
        detailButton.setTitle("자세히 보기                                                                                              ", for: .normal)
        detailButton.setImage(UIImage(systemName: "greaterthan"), for: .normal)
        detailButton.titleLabel?.font = .boldSystemFont(ofSize: 12)
        detailButton.tintColor = .darkGray
        detailButton.semanticContentAttribute = .forceRightToLeft
    }
}
