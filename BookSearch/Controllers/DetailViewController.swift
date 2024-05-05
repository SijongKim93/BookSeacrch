//
//  DetailViewController.swift
//  BookSearch
//
//  Created by 김시종 on 5/4/24.
//

import UIKit
import SnapKit
import JJFloatingActionButton


class DetailViewController: UIViewController {
    static let identifier = "DetailView"
    
    let mainTitle: UILabel = {
        var label =  UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let subTitle: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .systemGray5
        return label
    }()
    
    let bookImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    let bookPrice: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let bookContents: UILabel = {
       var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let actionButton = JJFloatingActionButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addFloatingButton()
        view.backgroundColor = .white
    }
    
    
    func setupView() {
        view.addSubview(mainTitle)
        view.addSubview(subTitle)
        view.addSubview(bookImageView)
        view.addSubview(bookPrice)
        
        
        mainTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        subTitle.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        bookImageView.snp.makeConstraints {
            $0.top.equalTo(subTitle.snp.bottom).offset(20)
            $0.width.equalTo(170)
            $0.height.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        bookPrice.snp.makeConstraints {
            $0.top.equalTo(bookImageView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        
        
    }
    
    func addFloatingButton() {
        actionButton.addItem(title: "책 담기", image: UIImage(systemName: "book.fill")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
        }

        actionButton.addItem(title: "찜하기", image: UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
        }

        actionButton.addItem(title: "뒤로가기", image: UIImage(systemName: "return")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
        }
        
        actionButton.display(inViewController: self)
        
    }
}
