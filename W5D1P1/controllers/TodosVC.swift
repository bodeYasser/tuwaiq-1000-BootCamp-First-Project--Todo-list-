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
        todosArray = Storage.getStoredTodos()
        todosTableView.dataSource = self
        todosTableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdded) , name: NSNotification.Name(rawValue: "newTodoAdded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(editTodo) , name: NSNotification.Name(rawValue: "todoNeedToEdit"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTodo) , name: NSNotification.Name(rawValue: "deletedTodo"), object: nil)
        
    }
    
    @objc func newTodoAdded (newNotification : Notification){
        
        
        if let newTodo = newNotification.userInfo?["hi"] as? Todo {
            
            todosArray.append(newTodo)
            Storage.storeTodo(todo: newTodo)
            todosTableView.reloadData()
        }
        
        
    }
    
    @objc func deleteTodo (newNotification : Notification){
        
        
        if let deleteIndex = newNotification.userInfo?["deletedTodoIndex"] as? Int {
            
            todosArray.remove(at: deleteIndex)
            Storage.deleteTodoCoreData(index: deleteIndex)
            todosTableView.reloadData()
        }
        
    }
    
    @objc func editTodo(todoNeedEdit : Notification)
    {
        if let editedTodo = todoNeedEdit.userInfo?["todo"] as? Todo , let todoIndex = todoNeedEdit.userInfo?["todoIndex"] as? Int
        {
            todosArray[todoIndex] = editedTodo
            Storage.updateTodo(todo: editedTodo, index: todoIndex)
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



/*
في مشكله غريبه اوي في الرنامج صوره الورده البنفسجيه لما تحفظها وتجعها تاني بتتقلب في بس باقي الصور لا
*/
