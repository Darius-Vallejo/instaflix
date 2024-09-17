//
//  CoreDataStack.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 9/09/24.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "instaflix")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


extension NSManagedObjectContext {
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) async throws -> [T] {
        return try await withCheckedThrowingContinuation { continuation in
            let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: request) { result in
                guard let result = result.finalResult else {
                    continuation.resume(throwing: NSError(domain: "FetchError", code: 1, userInfo: nil))
                    return
                }
                continuation.resume(returning: result)
            }

            do {
                try self.execute(asynchronousFetchRequest)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
