//
//  LocalRepository.swift
//  Lennach
//
//  Created by Sergey Fominov on 18/04/2019.
//  Copyright © 2019 CaramelHeaven. All rights reserved.
//

import Foundation
import CoreData

class LocalRepository {
    static let instance = LocalRepository()
    private let localMapper = LocalMainMapper()

    private init() { }

    func addToFavouriteThread(boardName: String, numThread: String, imageUrl: String, quantityPosts: Int, opMessage: String, completion: @escaping (Bool) -> Void) {
        let savedThread = ThreadFavourite(boardName: boardName, numThread: numThread, imageUrl: imageUrl, quantityPosts: quantityPosts, opMessage: opMessage)
        persistentContainer.performBackgroundTask { childContext in
            var favouriteThread = FavouriteThreadDb(context: childContext)
            self.localMapper.mapThreadToFavouriteInDatabase(savedThread, threadDb: &favouriteThread)

            do {
                try childContext.save()

                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                }
                print("fatal Error: \(error)")
            }
        }
    }

    func removeFromFavouriteThread(idThread: String) {

    }

    func provideSavedFavouritesBoard(completion: @escaping (Any?) -> Void) {
        let childContext = persistentContainer.newBackgroundContext()
        let fetchFavouriteThreads = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteThreadDb")
        let asynsRequest = NSAsynchronousFetchRequest(fetchRequest: fetchFavouriteThreads) { result in
            if let data = result.finalResult! as? [FavouriteThreadDb] {
                let objects = self.localMapper.mapDatabaseFavouriteThreadsToBusinessObjects(threadsDb: data)
                DispatchQueue.main.async {
                    completion(objects)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }

        do {
            try childContext.execute(asynsRequest)
        } catch let error {
            print("error: \(error)")
        }
    }

    //MARK: Handlers for working with CoreData
    func provideSaveBoardNavigation(array: [BoardDescription], completion: @escaping (Bool) -> Void) {
        persistentContainer.performBackgroundTask { childContext in
            for item in array {
                var boardDb = BoardDb(context: childContext)
                self.localMapper.mapNavigationBoardDataToDatabase(board: item, boardDb: &boardDb)
            }
            do {
                try childContext.save()

                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                }
            }

        }
    }

    func provideReadUserSavedBoards(completion: @escaping (Any?) -> Void) {
        let childContext = persistentContainer.newBackgroundContext()

        let fetchRequestBoards = NSFetchRequest<NSFetchRequestResult>(entityName: "BoardDb")
        let asynsRequesting = NSAsynchronousFetchRequest(fetchRequest: fetchRequestBoards) { result in
            if let data = result.finalResult! as? [BoardDb] {
                let objects = self.localMapper.mapDatabaseBoardToBusinessObjects(boardDb: data)
                DispatchQueue.main.async {
                    completion(objects)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }

        do {
            try childContext.execute(asynsRequesting)
        } catch let error {
            print("error: \(error)")
        }
    }

    //instance for connecting to coreData
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "App")

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in

            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

//MARK: CoreData handlers
extension LocalRepository {
    func saveDatabase() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("error, couldn't save to database during app exit")
            }
        }
    }
}
