//
//  ToDoListItem+CoreDataProperties.swift
//  CoreDataTutorial
//
//  Created by Robert Wong on 5/25/23.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    //How to query ToDoList items
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }
    
    @nonobjc public class func filterRequest(context: NSManagedObjectContext, queryString: String) -> [ToDoListItem]? {
        
        let fetchRequest = ToDoListItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name LIKE %@", "wave")
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            //Error with fetching request
        }
        return nil
    }

    //NSManaged is a managed context kind of like the reference in core data to be manipluated by the user
    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension ToDoListItem : Identifiable {

}
