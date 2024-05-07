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
    
    func deleteBookList(_ bookList: Document, completion: @escaping () -> Void) {
        guard let context = context else {
            print("content를 가져올 수 없습니다.")
            return
        }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: coreDataName)
        fetchRequest.predicate = NSPredicate(format: "title == %@", bookList.title)
        
        do {
            if let result = try context.fetch(fetchRequest) as? [NSManagedObject] {
                for object in result {
                    context.delete(object)
                }
                
                try context.save()
                print("삭제가 완료되었습니다.")
                completion()
            }
        } catch {
            print("삭제가 실패했습니다.", error)
            completion()
        }
    }
}
