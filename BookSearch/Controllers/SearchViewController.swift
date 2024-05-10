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
import CoreData



class SearchViewController: UIViewController, UISearchBarDelegate {
    
    weak var delegate: SearchViewControllerDelegate?
    
    let networkingManager = NetworkingManager.shared
    var bookData: BookData?
    var recentlyViewedBooks: [RecentlyBookInfo] = []
    
    var currentPage = 1
    var isEnd = false
    
    let searchBar = UISearchBar()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        view.backgroundColor = .white
        fetchBookData(withQuery: searchBar.text!, page: currentPage)
    }
    
    // MARK: - NetWork Data 가져오기
    func fetchBookData(withQuery query: String, page: Int) {
        networkingManager.fetchBookData(withQuery: query, page: currentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let bookData):
                if self.currentPage == 1 {
                    self.bookData = bookData
                } else {
                    self.bookData?.documents += bookData.documents
                }
                self.currentPage += 1
                self.isEnd = bookData.meta.isEnd
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch book data: \(error)")
            }
        }
    }
    
    // MARK: - Setup SearchBar
    func setupSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        searchBar.text = "해리"
        searchBar.placeholder = "원하는 책을 검색해주세요."
        searchBar.sizeToFit()
    }
    
    // MARK: - SeacrchBar 활성화 메서드
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            currentPage = 1
            fetchBookData(withQuery: query, page: 1)
        }
        searchBar.resignFirstResponder()
    }
    
    // MARK: - SeacrchBar 활성화 시 Cancel 버튼 활성화
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Setup CollectionView , CompositionalLayout Setting
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
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .absolute(200))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
                
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section?.interGroupSpacing = 10
            default:
                break
            }
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(0))
            let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            section?.boundarySupplementaryItems = [headerSupplementary]
            
            return section
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecentlyViewedCollectionViewCell.self, forCellWithReuseIdentifier: RecentlyViewedCollectionViewCell.identifier)
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, SearchViewControllerDelegate {
    
    // MARK: - SearchViewControllerDelegate 프로토콜 필수 메서드 구현
    func searchButtonPressed() {
        self.searchBar.becomeFirstResponder()
    }
    
    // MARK: - CollectionView Section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    // MARK: - CollectionView Cell Count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return recentlyViewedBooks.count
        } else {
            return bookData?.documents.count ?? 0
        }
    }
    
    // MARK: - CollectionView Cell Data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyViewedCollectionViewCell.identifier, for: indexPath) as? RecentlyViewedCollectionViewCell else { fatalError("에러입니다.") }
            cell.setupView()
            
            let recentBook = recentlyViewedBooks[indexPath.item]
            cell.titleLabel.text = recentBook.title
            
            if let url = URL(string: recentBook.thumbnail) {
                cell.bookImageView.kf.setImage(with: url)
            }
            
            cell.bookImageView.clipsToBounds = true
            cell.bookImageView.layer.cornerRadius = 16
            
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
    
    // MARK: - CollectionView HeaderView Setting
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected supplementary view kind")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView
        
        let sectionTitle: String?
        switch indexPath.section {
        case 0:
            if recentlyViewedBooks.isEmpty {
                sectionTitle = ""
                return headerView
            }
            sectionTitle = "⏰ 최근 본 책"
        case 1:
            sectionTitle = "📚 Book List"
        default:
            fatalError("Unknown section")
        }
        
        headerView.titleLabel.text = sectionTitle
        headerView.isHidden = false
        
        headerView.configure(title: sectionTitle ?? "")
        return headerView
    }
    
    // MARK: - CollectionView Cell 선택 시 상세 페이지 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            showBookRecent(at: indexPath)
            break
        case 1:
            addToRecentlyViewedBook(indexPath: indexPath)
            showBookDetail(at: indexPath)
        default:
            break
        }
    }
    
    // MARK: - CollectionView Cell 선택 시 상세 페이지 이동한 책 데이터 전달 (최근 본 책)
    func addToRecentlyViewedBook(indexPath: IndexPath) {
        guard let selectedBook = bookData?.documents[indexPath.item] else { return }
        
        if let existingIndex = recentlyViewedBooks.firstIndex(where: { $0.title == selectedBook.title }) {
            let recentlyBookInfo = recentlyViewedBooks.remove(at: existingIndex)
            recentlyViewedBooks.insert(recentlyBookInfo, at: 0)
        } else {
            let recentlyBookInfo = RecentlyBookInfo(title: selectedBook.title, thumbnail: selectedBook.thumbnail, authors: selectedBook.authors, price: selectedBook.price, contents: selectedBook.contents)
            recentlyViewedBooks.insert(recentlyBookInfo, at: 0)
        }
        collectionView.reloadData()
    }
    
    // MARK: - 상세페이지 이동 및 데이터 전달
    func showBookDetail(at indexPath: IndexPath) {
        let detailVC = DetailViewController()
        let bookData = bookData?.documents[indexPath.item]
        
        detailVC.bookData = bookData
        detailVC.delegate = self
        
        detailVC.mainTitle.text = bookData?.title
        detailVC.bookContents.text = bookData?.contents
        detailVC.subTitle.text = bookData?.authorsToString()
        detailVC.bookPrice.text = bookData?.formattedPrice()
        
        if let imageURL = bookData?.thumbnail, let imageURL = URL(string: imageURL) {
            detailVC.bookImageView.kf.setImage(with: imageURL)
        }
        
        present(detailVC, animated: true, completion: nil)
    }
    
    // MARK: - 최근 본 책 데이터 전달, 상세페이지 이동 및 데이터 전달
    func showBookRecent(at indexPath: IndexPath) {
        let detailVC = DetailViewController()
        let recentBook = recentlyViewedBooks[indexPath.item]
        let bookData = bookData?.documents[indexPath.item]
        
        detailVC.bookData = bookData
        detailVC.delegate = self
        
        detailVC.mainTitle.text = recentBook.title
        detailVC.subTitle.text = recentBook.authorsToString()
        detailVC.bookContents.text = recentBook.contents
        detailVC.bookPrice.text = recentBook.formattedPrice()
        if let imageURL = URL(string: recentBook.thumbnail) {
            detailVC.bookImageView.kf.setImage(with: imageURL)
        }
        
        present(detailVC, animated: true, completion: nil)
    }
    
    // MARK: - 무한 스크롤 구현
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isEnd && indexPath.item == (collectionView.numberOfItems(inSection: indexPath.section) - 1) {
            fetchNextPage()
        }
    }
    
    func fetchNextPage() {
        guard let query = searchBar.text else { return }
        fetchBookData(withQuery: query, page: currentPage)
    }
}


// MARK: - 화면 전환 및 서치바 활성화 프로토콜 구현
protocol SearchViewControllerDelegate: AnyObject {
    func searchButtonPressed()
}
