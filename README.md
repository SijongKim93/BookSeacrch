📚 Book Search

```

원하는 책을 모아 검색하고 담아두고 저장할 수 있는 앱 📚

```

---

## Table of Contents

1. [Description](#%EF%B8%8F-description)
2. [Stacks](#%EF%B8%8F-stacks)
3. [Main Feature](#-main-feature)
4. [Project Structure](#%EF%B8%8F-project-structure)

</br>

## Description

`base` : Code Base
`Period` : 24.04.30 ~ 24.05.09

현재 시중에 확인되는 책 정보를 모두 담고 있는 카카오 북 검색 API 를 활용한 책 검색 앱

</br>

## 🛠️ Stacks

**Environment**

<img src="https://img.shields.io/badge/-Xcode-147EFB?style=flat&logo=xcode&logoColor=white"/> <img src="https://img.shields.io/badge/-git-F05032?style=flat&logo=git&logoColor=white"/> <img src="https://img.shields.io/badge/-github-181717?style=flat&logo=github&logoColor=white"/>

**Language**

<img src="https://img.shields.io/badge/-swift-F05138?style=flat&logo=swift&logoColor=white"/>

</br>

## 🔧 Requirements

- App requires **iOS 15 or above**

</br>

---

## 🎯 Main Feature

### 1) Book Search

<img width="200" src ="https://github.com/SijongKim93/BookSeacrch/assets/158182449/5d7ec8a8-6d1c-47d4-815f-670f7ba4c994">
<img width="200" src ="https://github.com/SijongKim93/BookSeacrch/assets/158182449/ede8f6fc-c525-46e0-9252-3ae80ce13ef2">
<img width="200" src ="https://github.com/SijongKim93/BookSeacrch/assets/158182449/a3ed0266-81a3-4fe0-9a71-e0ffbfd8ef1c"><br><br>

- 카카오 책 검색 API 사용
- Infinite Scroll 적용하여 많은 데이터 확인 가능
- 최근 본 책 데이터가 생길 경우 최근 본 책 CollectinView 생성
- CompositionalLayout 적용

</br>

### 2) Detail Book

<img width="200" src ="https://github.com/SijongKim93/BookSeacrch/assets/158182449/22af1fd9-98ca-4c89-abe8-3b25426b016c">
<img width="200" src ="https://github.com/SijongKim93/BookSeacrch/assets/158182449/d8cb9960-ca47-4e87-a102-47a16aa21fac">
<img width="200" src ="https://github.com/SijongKim93/BookSeacrch/assets/158182449/16377b74-581a-40b0-907d-30a3d4e47484"><br><br>

- Core Data 를 활용해 저장된 책 저장
- 이미 저장된 책 저장 시 중복 저장 불가 안내
- 저장 된 시간대 순으로 Core Data 정렬
- Floting Button 활용해 다양한 기능을 가진 버튼 정렬 및 사용
- Alert을 활용해 상황 별 안내 메시지 안내

</br>

### 3) My Page

<img width="200" src ="https://github.com/SijongKim93/BookSeacrch/assets/158182449/1b14f0fe-4d6c-4b4c-8894-f15a9526806b">
<img width="200" src ="https://github.com/SijongKim93/BookSeacrch/assets/158182449/6a913f45-17b5-447b-a523-8e0a0caf17f5">
<img width="200" src ="https://github.com/SijongKim93/BookSeacrch/assets/158182449/d62f320d-3cb8-416d-8813-1bce3cf2ecaf"><br><br>

- 원하는 책을 담으면 MyPage 내 코어데이터로 저장된 책 확인
- 개별 삭제 및 전체 삭제 기능 구현

</br>

<br>

## 🏛️ Project Structure

```markdown
BookSearch
│   ├── AppDelegate
│   ├── SceneDelegate
├── Networking
│   ├── NetworkingManager
├── Model
│   ├── Product+CoreDataProperties
│   ├── Product+CoreDataClass
│   ├── BookData
│   ├── RecentlyBookInfo
│   ├── WishMovieData
│   └── CoreDataManager
├── View
│   ├── HeaderView
│   ├── RecentlyViewedCollectionViewCell
│   ├── BookCollectionViewCell
│   ├── MypageTableViewCell
│   └── MovieSearch
├── Controller
│   ├── SearchViewController
│   ├── MyPageViewController
│   └── DetailViewController

```

<br>
