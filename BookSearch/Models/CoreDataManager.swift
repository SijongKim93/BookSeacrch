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

    let coreDataName: String = "BookList"
    
    
    func getBookListFromCoreData() -> [BookList] {
        var bookList: [BookList] = []
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.coreDataName)
            let idOrder = NSSortDescriptor(key: "id", ascending: true)
            request.sortDescriptors = [idOrder]
            
            do {
                if let fetchBookList = try context.fetch(request) as? [BookList] {
                    bookList = fetchBookList
                }
            } catch {
                print("가져오기 실패")
            }
        }
        
        return bookList
    }
    
    
    func saveWishListData(_ product: Document, completion: @escaping () -> Void) {
        guard let context = context else {
            print("context를 가져올 수 없습니다.")
            return
        }
        
        if let entity = NSEntityDescription.entity(forEntityName: coreDataName, in: context) {
            let newProduct = NSManagedObject(entity: entity, insertInto: context)
            newProduct.setValue(product.authors, forKey: "authors")
            newProduct.setValue(product.title, forKey: "title")
            newProduct.setValue(product.price, forKey: "price")
            
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
    
    func deleteBookList(_ product: Document, completion: @escaping () -> Void) {
        guard let context = context else {
            print("content를 가져올 수 없습니다.")
            return
        }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: coreDataName)
        fetchRequest.predicate = NSPredicate(format: "title == %@", product.title)
        
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
