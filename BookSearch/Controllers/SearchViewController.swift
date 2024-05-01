//
//  ViewController.swift
//  BookSearch
//
//  Created by 김시종 on 4/30/24.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    let sectionTitles = ["최근 본 책", "Book List"]
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "원하는 책을 검색해주세요."
        return searchController
    }()
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        view.backgroundColor = .white
    }
    
    func setupSearchBar() {
        view.addSubview(searchController.searchBar)
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        searchController.searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    
    
    func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            var section: NSCollectionLayoutSection?
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .estimated(130))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section?.interGroupSpacing = 5
                section?.orthogonalScrollingBehavior = .continuous
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
                
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(170))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section?.interGroupSpacing = 10
            default:
                break
            }
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30))
            let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section?.boundarySupplementaryItems = [headerSupplementary]
            
            return section
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecentlyViewedCollectionViewCell.self, forCellWithReuseIdentifier: RecentlyViewedCollectionViewCell.identifier)
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchController.searchBar.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyViewedCollectionViewCell.identifier, for: indexPath) as? RecentlyViewedCollectionViewCell else { fatalError("에러입니다.") }
            cell.backgroundColor = .blue
            cell.setupView()
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as? BookCollectionViewCell else { fatalError("에러입니다.") }
            cell.backgroundColor = .brown
            cell.setupView()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected supplementary view kind")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView
        
        // 각 섹션에 대한 타이틀 설정
        let sectionTitle: String
        switch indexPath.section {
        case 0:
            sectionTitle = "최근 본 책"
        case 1:
            sectionTitle = "Book List"
        default:
            fatalError("Unknown section")
        }
        
        headerView.configure(title: sectionTitle)
        
        return headerView
    }
}
