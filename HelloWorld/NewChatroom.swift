//
//  NewChatroom.swift
//  Caritathelp
//
//  Created by Jeremy gros on 11/10/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SnapKit
import SCLAlertView

class NewChatroomController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user : JSON = []
    var AssocID = ""
    var request = RequestModel()
    var param = [String: Any]()
    var friends : JSON = []
    var newID: String = ""
    
    
    @IBOutlet weak var titleChatroom: UITextField!
    @IBOutlet weak var friends_list: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friends_list.tableFooterView = UIView()
        
        user = sharedInstance.volunteer["response"]
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        
        let val = "volunteers"
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.friends = User["response"]
                self.friends_list.reloadData()
                
            }
            else {
                
            }
        });
        
    }
    
    @IBAction func InviteMember(_ sender: AnyObject) {
        var i = 0
        var tab_chatter = [String]()
        
        //var id: Int!
        var count = 0
        while i < friends.count {
            //let rowToSelect: IndexPath = IndexPath(forRow: i, inSection: 0) //NSIndexPath(forRow: i, inSection: 0)
            
            let cell = friends_list.cellForRow(at: IndexPath(row: i, section: 0))
            
            if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
                //var preId = String(describing: friends[i]["id"])
                //var id = Int(preId)
                tab_chatter.append(String(describing: friends[i]["id"]))
                count += 1
            }
            i += 1
        }
        
        if count == 0 {
            SCLAlertView().showError("Erreure de création", subTitle: "Ajouter des volontaires !")
            return
        }
        //tab_chatter = tab_chatter + String(describing: user["id"]) + "]"
        
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        self.param["name"] = titleChatroom.text
        self.param["volunteers[]"] = tab_chatter.description
        let val = "chatrooms"
        print(self.param)
        request.request(type: "POST", param: self.param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.newID = String(describing: User["response"]["id"])
                SCLAlertView().showSuccess("Chatroom créer!", subTitle: "Vous pouvez maintenant discutez avec les amis que vous avez choisit.")
                self.navigationController?.popViewController(animated: true)
            }
            else {
                SCLAlertView().showError("Erreure de création", subTitle: "Contactez le sav")
                print("n'a pas pu etre ajouter")
            }
        });

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomCellInviteMember  = friends_list.dequeueReusableCell(withIdentifier: "getuserschatroom", for: indexPath as IndexPath) as! CustomCellInviteMember
        
        let name = String(describing: friends[indexPath.row]["firstname"]) + " " + String(describing: friends[indexPath.row]["lastname"])
        
        cell.setCell(NameLabel: name, imageName: define.path_picture + String(describing: friends[indexPath.row]["thumb_path"]))
        
        return cell
    }
    
    //renvoi le nombre de ligne du tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let cell = friends_list.cellForRow(at: indexPath as IndexPath)
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
            cell!.accessoryType = UITableViewCellAccessoryType.none;
            
        }else{
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark;
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        
        let cell = friends_list.cellForRow(at: indexPath as IndexPath)
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
            cell!.accessoryType = UITableViewCellAccessoryType.none;
            
        }else{
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark;
            
        }
    }//fromcreatechatroom
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // get a reference to the second view controller
    //    if(segue.identifier == "fromcreatechatroom"){
            //let secondViewController = segue.destination as! chatroomController
        // set a variable in the second view controller with the String to pass
            
           // secondViewController.chatroomID = self.newID
    //    }
    //}


}