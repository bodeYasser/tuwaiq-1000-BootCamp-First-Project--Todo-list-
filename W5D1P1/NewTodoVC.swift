//
//  NewTodoVC.swift
//  W5D1P1
//
//  Created by Abdallah yasser on 05/05/2022.
//

import UIKit

class NewTodoVC: UIViewController {
    var editTodo = false
    var theTodo : Todo?
    var todoIndex : Int?
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var todoTitleTF: UITextField!
    @IBOutlet weak var todoDetailsTV: UITextView!
    @IBOutlet var todoImageView: UIImageView!
    @IBOutlet weak var mainButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        if editTodo {
            navigationItem.title = "تعديل مهمه"
            mainButton.setTitle("تعديل", for: .normal)
            todoTitleTF.text = theTodo?.title
            todoTitleTF.textAlignment = NSTextAlignment.right
            todoDetailsTV.text = theTodo?.details
            todoImageView.image = theTodo?.image
            
        }
        else{
            
        }
        
        
    }
    
    // load image button or edit
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        //imagePicker.allowsEditing = false
        //imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // add or edit misson
    @IBAction func addButtonClicked(_ sender: Any) {
        
        if editTodo {
            
            let newTodo = Todo(title: todoTitleTF.text!,image :todoImageView.image, details: todoDetailsTV.text!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "todoNeedToEdit"), object: nil,userInfo: ["todo" : newTodo,"todoIndex" :todoIndex!])
            
            let alert = UIAlertController(title: "تم التعديل", message: "يمكن العوده", preferredStyle: .alert)
            let action = UIAlertAction(title: "انهاء", style: .default) { _ in
                //                let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainVC")
                //                self.navigationController?.pushViewController(vc!, animated: true)
                 self.navigationController?.popViewController(animated: true)
                 self.navigationController?.popViewController(animated: false)
                
                
                // tried to pop up twice at one time
//                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC")
//                {
//                    self.navigationController?.popToViewController(vc, animated: true)
//                }
            }
            alert.addAction(action)
            present(alert, animated: true)
            
            
            
        }
        else{
            
            let newTodo = Todo(title: todoTitleTF.text!,image: todoImageView.image,details: todoDetailsTV.text!)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newTodoAdded"), object: nil,userInfo: ["hi" : newTodo])
            
            
            let alert = UIAlertController(title: "تمت الاضافه", message: "شكرا", preferredStyle: .alert)
            let action = UIAlertAction(title: "انهاء", style: .default) { _ in
                //                let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainVC")
                //                self.navigationController?.pushViewController(vc!, animated: true)
                self.tabBarController?.selectedIndex = 0
                self.todoTitleTF.text = ""
                self.todoDetailsTV.text = ""
            }
            alert.addAction(action)
            present(alert, animated: true)
            
            
        }
        
    }
    
    
}

extension NewTodoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //imageView.contentMode = .scaleAspectFit
            todoImageView.image = pickedImage
            //theTodo?.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}


