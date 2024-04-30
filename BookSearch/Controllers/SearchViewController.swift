//
//  ViewController.swift
//  BookSearch
//
//  Created by 김시종 on 4/30/24.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    let searchController: UISearchController = {
       let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "원하는 책을 검색해주세요."
        return searchController
    }()
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    var contentView = UIView()
    
    var recentlyCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .absolute(150))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 5
            
            return section
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecentlyViewedCollectionViewCell.self, forCellWithReuseIdentifier: "RecentlyCollectionViewCell")
        collectionView.backgroundColor = .blue
        return collectionView
    }()
    
    var bookCollectinView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            return section
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "BookCollectionViewCell")
        collectionView.backgroundColor = .gray
        return collectionView
    }()
    
    var recentlyLabel: UILabel = {
       let label = UILabel()
        label.text = "최근 본 책"
        label.textAlignment = .left
        return label
    }()
    
    var bookLabel:UILabel = {
        let label = UILabel()
        label.text = "BOOK"
        label.textAlignment = .left
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupLabel()
        setupScrollView()
        view.backgroundColor = .white
    }
    
    func setupSearchBar() {
        contentView.addSubview(searchController.searchBar)
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(recentlyLabel)
        contentView.addSubview(recentlyCollectionView)
        contentView.addSubview(bookLabel)
        contentView.addSubview(bookCollectinView)
        
        setupLayout()
    }
    
    func setupLabel() {
        
    }
    
    func setupLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        searchController.searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        recentlyLabel.snp.makeConstraints {
            $0.top.equalTo(searchController.searchBar.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().offset(10)
        }
        
        recentlyCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentlyLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(150)
        }
        
        bookLabel.snp.makeConstraints {
            $0.top.equalTo(recentlyCollectionView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(5)
        }
        
        bookCollectinView.snp.makeConstraints {
            $0.top.equalTo(bookLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(700)
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentlyCollectionViewCell", for: indexPath) as? RecentlyViewedCollectionViewCell else { fatalError("에러입니다.") }
        
        cell.backgroundColor = .yellow
        
        return cell
    }
}
