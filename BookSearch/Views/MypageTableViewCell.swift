//
//  MypageTableViewCell.swift
//  BookSearch
//
//  Created by 김시종 on 5/5/24.
//

import UIKit
import SnapKit


class MypageTableViewCell: UITableViewCell {

    static let identifier = "MypageTableViewCell"
    
    let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        return stackView
    }()
    
    let mainTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    let priceTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {

        cellStackView.addArrangedSubview(mainTitle)
        cellStackView.addArrangedSubview(subTitle)
        cellStackView.addArrangedSubview(priceTitle)
        
        contentView.addSubview(cellStackView)
        
        cellStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        mainTitle.snp.makeConstraints {
            $0.width.equalTo(cellStackView.snp.width).multipliedBy(2/5.0)
        }
        
        subTitle.snp.makeConstraints {
            $0.width.equalTo(cellStackView.snp.width).multipliedBy(1.5/5.0)
        }
        
        priceTitle.snp.makeConstraints {
            $0.width.equalTo(cellStackView.snp.width).multipliedBy(1.5/5.0)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
