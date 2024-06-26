//
//  BookCollectionViewCell.swift
//  BookSearch
//
//  Created by 김시종 on 4/30/24.
//

import UIKit
import SnapKit

class BookCollectionViewCell: UICollectionViewCell {
    static let identifier = "BookCollectionViewCell"
    
    var bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    func setupView() {
        contentView.addSubview(bookImageView)
        contentView.addSubview(titleLabel)
        
        bookImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.9)
        }
          
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bookImageView.snp.bottom).offset(5)
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
}
