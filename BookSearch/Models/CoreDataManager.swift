//
//  CoreDataManager.swift
//  BookSearch
//
//  Created by 김시종 on 5/6/24.
//

import UIKit
import CoreData


class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let coreDataName: String = "BookCoreData"
    
    func getBookListFromCoreData() -> [BookCoreData] {
        var bookList: [BookCoreData] = []
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.coreDataName)
            let idOrder = NSSortDescriptor(key: "title", ascending: true)
            request.sortDescriptors = [idOrder]
            
            do {
                if let fetchBookList = try context.fetch(request) as? [BookCoreData] {
                    bookList = fetchBookList
                }
            } catch {
                print("가져오기 실패")
            }
        }
        
        return bookList
    }
    
    
    func saveBookListData(_ booklist: Document, completion: @escaping () -> Void) {
        guard let context = context else {
            print("context를 가져올 수 없습니다.")
            return
        }
        
        if let entity = NSEntityDescription.entity(forEntityName: coreDataName, in: context) {
            let newProduct = NSManagedObject(entity: entity, insertInto: context)
            let authorsString = booklist.authors.joined(separator: ", ")
            newProduct.setValue(authorsString, forKey: "authors")
            newProduct.setValue(booklist.title, forKey: "title")
            newProduct.setValue(booklist.price, forKey: "price")
            
            do {
                try context.save()
                print("코어데이터에 저장되었습니다.")
                completion()
            } catch {
                print("코어데이터에 저장하는데 실패했습니다.", error)
                completion()
            }
        }
    }
    
    func deleteBookList(_ bookList: BookCoreData, completion: @escaping () -> Void) {
        guard let context = context else {
            print("content를 가져올 수 없습니다.")
            return
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BookCoreData")
        request.predicate = NSPredicate(format: "title = %@", bookList.title ?? 0)
        
        do {
            let fetchResults = try context.fetch(request) as? [NSManagedObject]
            if let fetchedBook = fetchResults?.first {
                context.delete(fetchedBook)
                try context.save()
                completion()
            } else {
                print("해당하는 책이 존재하지 않습니다.")
            }
        } catch {
            print("책 삭제에 실패했습니다: \(error)")
        }
    }
    
    func deleteAllBooks(completion: @escaping () -> Void) {
        guard let context = context else {
            print("CoreData context가 유효하지 않습니다.")
            return
        }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "BookCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            completion()
        } catch {
            print("전체 책 삭제에 실패했습니다: \(error)")
        }
    }
}