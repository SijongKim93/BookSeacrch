//
//  MyPageViewController.swift
//  BookSearch
//
//  Created by 김시종 on 4/30/24.
//

import UIKit
import SnapKit

class MyPageViewController: UIViewController {
    
    let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        return stackView
    }()
    
    let leftButton: UIButton = {
       let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    let rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        return button
    }()
    
    let centerLabel: UILabel = {
        let label = UILabel()
        label.text = "마이 페이지"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let mypageTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
    }
    
    func setupUI() {
        view.addSubview(topStackView)
        view.addSubview(mypageTableView)
        topStackView.addArrangedSubview(leftButton)
        topStackView.addArrangedSubview(centerLabel)
        topStackView.addArrangedSubview(rightButton)
        
        mypageTableView.dataSource = self
        mypageTableView.delegate = self
        mypageTableView.register(MypageTableViewCell.self, forCellReuseIdentifier: MypageTableViewCell.identifier)
        
        topStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(50)
        }
        
        mypageTableView.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom).offset(30)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            
        }
    }
}


extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MypageTableViewCell.identifier, for: indexPath) as? MypageTableViewCell else { fatalError("테이블 뷰 에러") }
        
        
        return cell
    }
    
    
    
}
