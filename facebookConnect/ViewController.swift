//
//  ViewController.swift
//  facebookConnect
//
//  Created by Apple on 11/6/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

import FacebookLogin
import FacebookCore


class ViewController: UIViewController {


    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginButton()
        fetchRequest()
        
        
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = self.avatar.frame.width / 2
    }
    
    fileprivate func setupLoginButton() {
        let button = FBLoginButton(permissions:[.email, .publicProfile])
        
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func fetchRequest() {
        let graphREquest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, picture.width(400).height(400)"])
        
        
        graphREquest.start { (connection, result, err) in
            if (err != nil) {
                print(err?.localizedDescription)
            } else {
                print(" ket qua nhan duoc la: \(result)")
                
                for (key, value) in result as! [String: AnyObject] {
                    switch key {
                    case "id":
                        self.idLabel.text = value as! String
                    case "name":
                        self.nameLabel.text = value as! String
                    case "picture":
                        let data = value as! [String: AnyObject]
                        let anotherdata = data["data"] as! [String: AnyObject]
                         let urlString = anotherdata["url"] as! String
                        self.avatar.image = self.getImage(urlString: urlString)
                    default:
                        return
                    }
                }
            }
        }
    }
    

    func getImage(urlString: String) -> UIImage {
        guard let url = URL(string: urlString) else { return UIImage()}
         let data = try? Data(contentsOf: url)
        return UIImage(data: data!)!
    }
}

