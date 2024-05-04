//
//  ViewController.swift
//  BookSearch
//
//  Created by 김시종 on 4/30/24.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    let networkingManager = NetworkingManager.shared
    var bookData: BookData?
    
    
    let searchBar = UISearchBar()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        fetchBookData(withQuery: "세이노")
        configure()
    }
    
    func configure() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .white
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func fetchBookData(withQuery query: String) {
        networkingManager.fetchBookData(withQuery: query) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let bookData):
                self.bookData = bookData
                print(bookData)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch book data: \(error)")
            }
        }
    }
    
    func setupSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.placeholder = "원하는 책을 검색해주세요."
        searchBar.sizeToFit()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            fetchBookData(withQuery: query)
        }
        searchBar.resignFirstResponder()
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
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .absolute(160))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
                
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(180))
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
        collectionView.backgroundColor = .systemGray5
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 10
        } else {
            return bookData?.documents.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyViewedCollectionViewCell.identifier, for: indexPath) as? RecentlyViewedCollectionViewCell else { fatalError("에러입니다.") }
            cell.backgroundColor = .blue
            cell.setupView()
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as? BookCollectionViewCell else { fatalError("에러입니다.") }
            cell.setupView()
            
            if let document = bookData?.documents[indexPath.item] {
                cell.titleLabel.text = document.title
                
                if let url = URL(string:  document.thumbnail) {
                    cell.bookImageView.kf.setImage(with: url)
                }
            }
            
            cell.bookImageView.clipsToBounds = true
            cell.bookImageView.layer.cornerRadius = 16
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected supplementary view kind")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView
        
        let sectionTitle: String
        switch indexPath.section {
        case 0:
            sectionTitle = "최근 본 책"
        case 1:
            sectionTitle = "Best List"
        default:
            fatalError("Unknown section")
        }
        
        headerView.configure(title: sectionTitle)
        
        return headerView
    }
}
