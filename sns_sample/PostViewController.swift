//
//  PostViewController.swift
//  sns_sample
//
//  Created by Kiyoshi Ohashi on 2022/12/09.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PostViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleTextField.text = ""
        contentTextView.text = ""
    }
    
    @IBAction func postButton() {
        if(titleTextField.text != "" && contentTextView.text != "") {
            Firestore.firestore().collection("posts").document().setData([
                "title": titleTextField.text ?? "title:Error",
                "content": contentTextView.text ?? "content:Error",
                "uid": Auth.auth().currentUser?.uid ?? "uid:Error",
                "created_at": Date(),
            ])
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "注意", message: "入力されていない項目があります", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButton() {
        self.dismiss(animated: true, completion: nil)
    }

}
