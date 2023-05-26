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
    
//    @nonobjc public class func filterRequest(entity: NSFetchRequest<ToDoListItem>, queryString: String) ->
    @nonobjc public class func filterRequest(context: NSManagedObjectContext, queryString: String) -> [ToDoListItem]? {
        do {
            let database = try context.fetch(ToDoListItem.fetchRequest())
        } catch {
            //error handling for if databse doesn't exist
        }
        fetchRequest().predicate = NSPredicate(format: "name LIKE %@", "\(queryString)")
        print("dasda")
        do {
            let objects = try context.fetch(fetchRequest())
            return objects
        } catch {
            //error for if filter doesn't work
        }
        return nil
    }

    //NSManaged is a managed context kind of like the reference in core data to be manipluated by the user
    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension ToDoListItem : Identifiable {

}
