//
//  ListViewController.swift
//  sns_sample
//
//  Created by Kiyoshi Ohashi on 2022/12/09.
//

import UIKit
import FirebaseFirestore

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var userListener: ListenerRegistration?
    var postListener: ListenerRegistration?
    var cellArray: [Dictionary<String, String>] = []
    var userArray: [Dictionary<String, String>] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        getUsers()
        getPosts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! ListTableViewCell
        cell.nameLabel.text = cellArray[indexPath.row]["name"] ?? "Name:Error"
        cell.titleLabel.text = cellArray[indexPath.row]["title"] ?? "Title:Error"
        cell.contentTextView.text = cellArray[indexPath.row]["content"] ?? "Content:Error"
        return cell
    }
    
    func getUsers() {
        let db = Firestore.firestore()
        userListener = db.collection("users").addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("Error!:", error)
            } else {
                print("user:success!")
                self.userArray = []
                if let documentSnapshots = documentSnapshot?.documents {
                    for document in documentSnapshots {
                        let data = document.data()
                        let user = [
                            "uid": data["uid"] as? String ?? "uid:Error",
                            "name": data["name"] as? String ?? "name:Error",
                        ]
                        self.userArray.append(user)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func getPosts() {
        let db = Firestore.firestore()
        postListener = db.collection("posts").order(by: "created_at").addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("Error!:", error)
            } else {
                print("post:success!")
                self.cellArray = []
                if let documentSnapshots = documentSnapshot?.documents {
                    for document in documentSnapshots {
                        let data = document.data()
                        let uid = data["uid"] as? String ?? "uid:Error"
                        let name = self.userArray.filter({ $0.values.contains(uid) })
                        var cell: Dictionary<String, String> = [
                            "title": data["title"] as? String ?? "title:Error",
                            "content": data["content"] as? String ?? "content:Error",
                            "name": name.first?["name"] ?? "name:Error",
                        ]
                        self.cellArray.append(cell)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func backButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
