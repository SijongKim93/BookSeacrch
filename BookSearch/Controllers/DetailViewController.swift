//
//  DetailViewController.swift
//  BookSearch
//
//  Created by 김시종 on 5/4/24.
//

import UIKit
import SnapKit
import JJFloatingActionButton
import CoreData


class DetailViewController: UIViewController {
    static let identifier = "DetailView"
    
    let mainTitle: UILabel = {
        var label =  UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let subTitle: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    let bookImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowRadius = 6
        imageView.layer.shadowOpacity = 0.5
        return imageView
    }()
    
    let bookPrice: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let bookContents: UILabel = {
       var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.numberOfLines = 0
        return label
    }()
    
    let actionButton = JJFloatingActionButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addFloatingButton()
        view.backgroundColor = .systemGray5
    }
    
    func setupView() {
        view.addSubview(mainTitle)
        view.addSubview(subTitle)
        view.addSubview(bookImageView)
        view.addSubview(bookPrice)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(bookContents)
        
        mainTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        subTitle.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        bookImageView.snp.makeConstraints {
            $0.top.equalTo(subTitle.snp.bottom).offset(30)
            $0.width.equalTo(250)
            $0.height.equalTo(350)
            $0.centerX.equalToSuperview()
        }
        
        bookPrice.snp.makeConstraints {
            $0.top.equalTo(bookImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(bookPrice.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        bookContents.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }
        
    }
    
//    func addBookToCoreData(_ product: Document) {
//        CoreDataManager.shared.saveWishListData() {
//            print("책이 코어 데이터에 저장되었습니다.")
//        }
//    }
    
    func addFloatingButton() {
        actionButton.addItem(title: "책담기", image: UIImage(systemName: "book.fill")?.withRenderingMode(.alwaysTemplate)) { item in

        }

        actionButton.addItem(title: "검색하기", image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
        }

        actionButton.addItem(title: "뒤로가기", image: UIImage(systemName: "return")?.withRenderingMode(.alwaysTemplate)) { item in
            self.dismiss(animated: true, completion: nil)
        }
        
        actionButton.display(inViewController: self)
    }
}
