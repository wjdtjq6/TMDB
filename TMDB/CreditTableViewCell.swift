//
//  CreditTableViewCell.swift
//  TMDB
//
//  Created by t2023-m0032 on 6/30/24.
//

import UIKit

class CreditTableViewCell: UITableViewCell {
    let overviewLable = UILabel()
    let expandButton = UIButton()
    let castImage = UIImageView()
    let castTitleLabel = UILabel()
    let castSubLabel = UILabel()

    static let id = "CreditTableViewCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    private func configureHierarchy() {
        contentView.addSubview(overviewLable)
        contentView.addSubview(expandButton)
        contentView.addSubview(castImage)
        contentView.addSubview(castTitleLabel)
        contentView.addSubview(castSubLabel)
    }
    private func configureLayout() {
        overviewLable.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(30)
        }
        expandButton.snp.makeConstraints { make in
            make.top.equalTo(overviewLable.snp.bottom)
            make.centerX.bottom.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        
        castImage.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.width.equalTo(60)
        }
        castTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp_centerYWithinMargins).offset(-20)
            make.leading.equalTo(castImage.snp.trailing).offset(20)
        }
        castSubLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp_centerYWithinMargins).offset(5)
            make.leading.equalTo(castImage.snp.trailing).offset(20)
        }
    }
    private func configureUI() {
        overviewLable.font = .systemFont(ofSize: 14)
        expandButton.tintColor = .black
        expandButton.addTarget(self, action: #selector(expandButtonClicked), for: .touchUpInside)
        
        castImage.clipsToBounds = true
        castImage.layer.cornerRadius = 10
        castSubLabel.font = .systemFont(ofSize: 14)
        castSubLabel.textColor = .lightGray
    }
    @objc private func expandButtonClicked() {
        overviewLable.numberOfLines = isSelected ? 2 : 0
        invalidateIntrinsicContentSize()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
