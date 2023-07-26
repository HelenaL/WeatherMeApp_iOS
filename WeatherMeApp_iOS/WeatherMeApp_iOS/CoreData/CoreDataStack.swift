//
//  CoreDataStack.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 3/25/23.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension CoreDataStack {
    func addNewCity(name: String, placemarkTitle: String, lat: Double, long: Double, timeZone: String) {
        let context = persistentContainer.viewContext
        let city = City(context: context)
        city.name = name
        city.placemarkTitle = placemarkTitle
        city.lat = lat
        city.long = long
        city.timeZone = timeZone
        
        do {
            try context.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteCity(city: City) {
        let context = persistentContainer.viewContext
        context.delete(city)
        
        do {
            try context.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getCitiesList() -> [City] {
        let context = persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<City>(entityName: "City")
        
        do {
            let cities = try context.fetch(fetchRequest)
            return cities
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return []
    }
    
    func isContainCity(placemarkTitle: String) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<City>(entityName: "City")
        fetchRequest.predicate = NSPredicate(format: "placemarkTitle == %@", placemarkTitle)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \City.name, ascending: true)]
        
        do {
            let cities = try context.fetch(fetchRequest)
            return !cities.isEmpty
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
       return false
    }
}
