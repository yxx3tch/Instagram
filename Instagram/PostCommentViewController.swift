//
//  PostCommentViewController.swift
//  Instagram
//
//  Created by yxx3tch on 2018/02/14.
//  Copyright © 2018年 yxx3tch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class PostCommentViewController: UIViewController {
    var postData: PostData!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func handlePostButton(_ sender: Any) {
        if let text = textField.text {
            if text.isEmpty {
                print("DEBUG_PRINT: コメントが空文字です。")
                SVProgressHUD.showError(withStatus: "コメントを入力して下さい")
                return
            }
            if let uid = Auth.auth().currentUser?.uid {
                let time = Date.timeIntervalSinceReferenceDate
                let comment = ["uid": uid, "name": Auth.auth().currentUser?.displayName, "comment": text, "time": String(time)]
                let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!).child("comments")
                
                postRef.childByAutoId().setValue(comment)
                SVProgressHUD.showSuccess(withStatus: "投稿しました")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func handleCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = postData.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
