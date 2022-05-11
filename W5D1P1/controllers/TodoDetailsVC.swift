//
//  TodoDetailsVC.swift
//  W5D1P1
//
//  Created by Abdallah yasser on 04/05/2022.
//

import UIKit

class TodoDetailsVC: UIViewController {
    
    
    var selectedTodo : Todo?
    var selectedTodoIndex : Int?
    @IBOutlet weak var detailsTitle: UILabel!
    @IBOutlet weak var detailsDescription: UILabel!
    @IBOutlet weak var detailsImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        detailsImage.image = selectedTodo?.image
        detailsTitle.text = selectedTodo?.title
        detailsDescription.text = selectedTodo?.details
        
    }
    @IBAction func editTodoButtonClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewTodoVC") as! NewTodoVC
        
        vc.editTodo = true
        vc.theTodo = selectedTodo
        vc.todoIndex = selectedTodoIndex
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func deleteButtonClicked() {
        
        let deleteAlert = MyAlertViewController(title: "انتبه", message: "انت علي وشك ان تحذف مهمه")
        deleteAlert.addAction(title: "حذف المهمه", style: .default) { _ in
            let doneDelete = MyAlertViewController(title : "تم الانتهاء" , message: "نجحه عمليه الحذف")
            doneDelete.addAction(title: "تم", style: .default){_ in
                self.navigationController?.popViewController(animated: true)
                
                NotificationCenter.default.post(name: NSNotification.Name("deletedTodo"), object: nil,userInfo: ["deletedTodoIndex" : self.selectedTodoIndex!])
            }
            self.present(doneDelete, animated: true)

        
        }
            //deleteAlert.addAction(title: "اغلاق", style: .default)
            deleteAlert.addAction(title: "الغاء الحذف" ,style: .cancel)
            present(deleteAlert,animated: true)
        
//        NotificationCenter.default.post(name: NSNotification.Name("deletedTodo"), object: nil,userInfo: ["deletedTodoIndex" : selectedTodoIndex!])
//
//        let deleteAlert = UIAlertController(title: "انتبه", message: "انت علي وشك ان تحذف مهمه", preferredStyle: .alert)
//
//        let confirmDelete = UIAlertAction(title: "حذف المهمه", style: .destructive) { ـ in
//            let doneDelete = UIAlertController(title: "تم الانتهاء", message: "نجحه عمليه الحذف", preferredStyle: .alert)
//
//            let exitDelete = UIAlertAction(title: "اغلاق", style: .default) { _ in
//                self.navigationController?.popViewController(animated: true)
//            }
//            doneDelete.addAction(exitDelete)
//            self.present(doneDelete, animated: true, completion: nil)
//
//
//        }
//        let cancelDelete = UIAlertAction(title: "الغاء الحذف", style: .default, handler: nil)
//        deleteAlert.addAction(confirmDelete)
//        deleteAlert.addAction(cancelDelete)
//        present(deleteAlert, animated: true, completion: nil)
        
            
    }
    
}
