//
//  TodosVC.swift
//  W5D1P1
//
//  Created by Abdallah yasser on 04/05/2022.
// 

import UIKit
import CoreData

class TodosVC: UIViewController {
    
    var todosArray : [Todo] = [
        //        Todo(title: "الذهاب الي الجامعه", image: UIImage(named: "Image.png")),
        //        Todo(title: "الافطار", image : UIImage(named: "Image-1.png")),
        //        Todo(title: "اخذ قسط من الراحه", image:UIImage(named: "Image-2.png")),
        //        Todo(title: "مقابله بعض الاصدقاء",details: "هشوف احمد - محمد - احمد - حموكشه"),
        //        Todo(title: "هلعب بنح"),
        //        Todo(title: "الذهاب الي المنزل", image: UIImage(named: "Image-3.png"))
    ]
    @IBOutlet weak var todosTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todosArray = getStoredTodos()
        todosTableView.dataSource = self
        todosTableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdded) , name: NSNotification.Name(rawValue: "newTodoAdded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(editTodo) , name: NSNotification.Name(rawValue: "todoNeedToEdit"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTodo) , name: NSNotification.Name(rawValue: "deletedTodo"), object: nil)
        
    }
    
    @objc func newTodoAdded (newNotification : Notification){
        
        
        if let newTodo = newNotification.userInfo?["hi"] as? Todo {
            
            todosArray.append(newTodo)
            storeTodo(todo: newTodo)
            todosTableView.reloadData()
        }
        
        
    }
    
    @objc func deleteTodo (newNotification : Notification){
        
        
        if let deleteIndex = newNotification.userInfo?["deletedTodoIndex"] as? Int {
            
            todosArray.remove(at: deleteIndex)
           deleteTodoCoreData(index: deleteIndex)
            todosTableView.reloadData()
        }
        
    }
    
    @objc func editTodo(todoNeedEdit : Notification)
    {
        if let editedTodo = todoNeedEdit.userInfo?["todo"] as? Todo , let todoIndex = todoNeedEdit.userInfo?["todoIndex"] as? Int
        {
            todosArray[todoIndex] = editedTodo
            updateTodo(todo: editedTodo, index: todoIndex)
            todosTableView.reloadData()
        }
        
    }
}



extension TodosVC : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todocell") as! TodoCellVC
        
        let item = todosArray[indexPath.row]
        cell.todoLabel.text = item.title
        cell.todoImage.image = item.image
        cell.todoImage.layer.cornerRadius = cell.todoImage.frame.width / 2
        // مع اني مخلي الwidth نفس ال height بس لما استخدم فوق ال height مش بيظبط وبيطلع كان طوله ١٣٩ تقريبا
        //
        //print(cell.todoImage.frame.width)
        //print(cell.todoImage.frame.height)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! TodoDetailsVC
        vc.selectedTodo = todosArray[indexPath.row]
        vc.selectedTodoIndex = indexPath.row
        //        present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

func storeTodo(todo : Todo){
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

func getStoredTodos() -> [Todo]{
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



func updateTodo(todo : Todo , index : Int) {
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



func deleteTodoCoreData( index : Int) {
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


/*
في مشكله غريبه اوي في الرنامج صوره الورده البنفسجيه لما تحفظها وتجعها تاني بتتقلب في بس باقي الصور لا
*/
