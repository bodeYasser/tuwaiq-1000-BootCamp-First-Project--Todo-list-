//
//  StorageVC.swift
//  W5D1P1
//
//  Created by Abdallah yasser on 09/05/2022.
//

import UIKit
import CoreData


class Storage {
    
    static func  storeTodo(todo : Todo){
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        //We need to createacontext from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        //Now let's create an entity and new user records.
        let todoEntity = NSEntityDescription.entity(forEntityName: "Todos", in: managedContext)!
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        
        
        let todoObject = NSManagedObject(entity: todoEntity, insertInto: managedContext)
        
        // : save photo
        let pngImage = todo.image?.pngData()
        // or let pngImage = todo.image?.jpegData(compressionQuality: <#T##CGFloat#>) // insert number
        
        todoObject.setValue(pngImage, forKey: "image")
        todoObject.setValue(todo.details, forKey: "details")
        todoObject.setValue(todo.title, forKey: "title")
        
        
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        do{
            try managedContext.save()
            print("congratulations")
        }catch let error as NSError{
            print ("Could not save. \(error), \(error.userInfo)")
        }
    }

    static func getStoredTodos() -> [Todo]{
        var todos :[Todo] = []
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return []}
        //We need to createacontext from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        //Prepare the request of type NSFetchRequest for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do{
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            for data in result {
                let title  = data.value(forKey: "title") as? String
                let details = data.value(forKey: "details") as? String
                let pngImage = data.value(forKey: "image") as? Data
                let image = UIImage(data: pngImage!)
                let todo = Todo(title: title!,image: image, details: details!)
                todos.append(todo)
                
            }
        }catch{
            print ("Failed")
        }
        return todos
    }



   static func updateTodo(todo : Todo , index : Int) {
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        //We need to createacontext from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        //Prepare the request of type NSFetchRequest for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do{
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            let pngImage = todo.image?.pngData()
            result[index].setValue(pngImage, forKey: "image")
            result[index].setValue(todo.title, forKey: "title")
            result[index].setValue(todo.details, forKey: "details")
            try managedContext.save()
        }catch{
            print ("Failed")
        }
    }



  static  func deleteTodoCoreData( index : Int) {
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        //We need to createacontext from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        //Prepare the request of type NSFetchRequest for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
        
        do{
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            let todoTodelete = result[index]
            managedContext.delete(todoTodelete)
            try managedContext.save()
        }catch{
            print ("Failed")
        }
    }

    
}
