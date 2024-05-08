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
    
    weak var delegate: SearchViewControllerDelegate?
    
    var bookData: Document?
    
    let bookImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowRadius = 6
        imageView.layer.shadowOpacity = 0.5
        return imageView
    }()
    
    let mainTitle: UILabel = {
        var label =  UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let subTitle: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    let bookPrice: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    let bookLabel: UILabel = {
        var label = UILabel()
        label.text = "책 소개"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let bookContents: UILabel = {
       var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
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
        view.addSubview(bookImageView)
        view.addSubview(mainTitle)
        view.addSubview(subTitle)
        view.addSubview(bookPrice)
        view.addSubview(bookLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(bookContents)
        
        
        bookImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.width.equalTo(200)
            $0.height.equalTo(250)
            $0.centerX.equalToSuperview()
        }
        
        mainTitle.snp.makeConstraints {
            $0.top.equalTo(bookImageView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        subTitle.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        bookPrice.snp.makeConstraints {
            $0.top.equalTo(subTitle.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        bookLabel.snp.makeConstraints {
            $0.top.equalTo(bookPrice.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(bookLabel.snp.bottom)
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
    
    func saveBookToCoreData() {
        guard let bookData = bookData else {
            print("bookData가 없습니다.")
            return
        }
        
        CoreDataManager.shared.saveBookListData(bookData) {
            print("코어데이터에 저장되었습니다.")
        }
    }
    
    func addFloatingButton() {
        actionButton.addItem(title: "책담기", image: UIImage(systemName: "book.fill")?.withRenderingMode(.alwaysTemplate)) { [self] item in
            self.saveBookToCoreData()
            
            let bookName = self.bookData?.title
            if let bookName = bookName {
                showAlert(message: "\(bookName) 저장되었습니다.")
            } else {
                showAlert(message: "책이름 없이 저장되었습니다.")
            }
        }
        
        actionButton.addItem(title: "검색하기", image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)) { item in
            self.dismiss(animated: true) {
                self.delegate?.searchButtonPressed()
            }
        }

        actionButton.addItem(title: "뒤로가기", image: UIImage(systemName: "return")?.withRenderingMode(.alwaysTemplate)) { item in
            self.dismiss(animated: true, completion: nil)
        }
        
        actionButton.display(inViewController: self)
    }
    
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
