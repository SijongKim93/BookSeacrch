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
            let request = NSFetchRequest<BookCoreData>(entityName: self.coreDataName)
            let dateOrder = NSSortDescriptor(key: "date", ascending: true)
            request.sortDescriptors = [dateOrder]
            
            do {
                bookList = try context.fetch(request)
            } catch {
                print("데이터를 가져오는데 실패했습니다:", error)
            }
        }
        return bookList
    }
    
    func saveBookListData(_ booklist: Document, completion: @escaping (Bool) -> Void) {
        guard let context = context else {
            print("context를 가져올 수 없습니다.")
            completion(false)
            return
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: coreDataName)
        request.predicate = NSPredicate(format: "title == %@", booklist.title)
        
        do {
            let count = try context.count(for: request)
            guard count == 0 else {
                print("이미 저장된 책입니다.")
                completion(false)
                return
            }
        } catch {
            print("중복 체크 실패:", error)
            completion(false)
            return
        }
        
        if let entity = NSEntityDescription.entity(forEntityName: coreDataName, in: context) {
            let newProduct = NSManagedObject(entity: entity, insertInto: context)
            let authorsString = booklist.authors.joined(separator: ", ")
            newProduct.setValue(authorsString, forKey: "authors")
            newProduct.setValue(booklist.title, forKey: "title")
            newProduct.setValue(booklist.price, forKey: "price")
            newProduct.setValue(Date(), forKey: "date")
            
            do {
                try context.save()
                print("코어데이터에 저장되었습니다.")
                completion(true)
            } catch {
                print("코어데이터에 저장하는데 실패했습니다.", error)
                completion(false)
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
