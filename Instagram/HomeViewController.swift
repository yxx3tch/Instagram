//
//  HomeViewController.swift
//  Instagram
//
//  Created by yxx3tch on 2018/02/12.
//  Copyright © 2018年 yxx3tch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []
    var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UIScreen.main.bounds.width + 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            if self.observing == false {
                let postRef = Database.database().reference().child(Const.PostPath)
                postRef.observe(.childAdded, with: { snapshot in
                    print("PRINT_DEBUG: .childAddedイベントが発生しました。")
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        self.postArray.insert(postData, at: 0)
                        
                        self.tableView.reloadData()
                    }
                })
                
                postRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました。")
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                        var index: Int = 0
                        for post in self.postArray {
                            if post.id == postData.id {
                                index = self.postArray.index(of: post)!
                                break
                            }
                        }
                        
                        self.postArray.remove(at: index)
                        self.postArray.insert(postData, at: index)
                        self.tableView.reloadData()
                    }
                })
                observing = true
            }
            
        } else {
            if observing == true {
                postArray = []
                tableView.reloadData()
                Database.database().reference().removeAllObservers()
                
                observing = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        // セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        cell.commentButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)

        return cell
    }
    
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData = postArray[indexPath!.row]
        if sender.tag == 0 {
            print("DEBUG_PRINT: likeボタンがタップされました。")
            if let uid = Auth.auth().currentUser?.uid {
                if postData.isLiked {
                    var index = -1
                    for likeId in postData.likes {
                        if likeId == uid {
                            index = postData.likes.index(of: likeId)!
                            break
                        }
                    }
                    postData.likes.remove(at: index)
                } else {
                    postData.likes.append(uid)
                }
                
                let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
                
                let likes = ["likes": postData.likes]
                postRef.updateChildValues(likes)
                
            }
        } else if sender.tag == 1 {
            print("DEBUG_PRINT: commentボタンがタップされました。")
            let postCommentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostComment") as! PostCommentViewController
            postCommentViewController.postData = postData
            self.present(postCommentViewController, animated: true, completion:  nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
