//
//  ProfilEvent.swift
//  Caritathelp
//
//  Created by Jeremy gros on 16/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class ProfilEventController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //variable utilisé dans cette classe
    var param = [String: String]()
    var request = RequestModel()
    var EventID : String = ""
    var Event : JSON = []
    var user : JSON = []
    var main_picture = ""
    var actu : JSON = []
    var rights = ""
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ProfilEventController.refresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    //variable en lien avec la storyBoard
    @IBOutlet weak var imageEvent: UIImageView!
    @IBOutlet weak var StateMembersOnEvent: UIButton!
    @IBOutlet weak var rightsButtonItem: UIBarButtonItem!
    @IBOutlet weak var eventsNewsList: UITableView!
    @IBOutlet weak var JoinEventBtn: UIBarButtonItem!
    @IBOutlet weak var publishButton: UIBarButtonItem!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell : CustomCellActu = eventsNewsList.dequeueReusableCell(withIdentifier: "customcellactu", for: indexPath) as! CustomCellActu
            
            cell.tapped_modify = { [unowned self] (selectedCell, Newcontent) -> Void in
                let path = tableView.indexPathForRow(at: selectedCell.center)!
                //let selectedItem = self.actu[path.section]["content"]
                
                self.param["access-token"] = sharedInstance.header["access-token"]
                self.param["client"] = sharedInstance.header["client"]
                self.param["uid"] = sharedInstance.header["uid"]
                self.param["content"] = Newcontent
                self.request.request(type: "PUT", param: self.param, add: "news/" + String(describing: self.actu[path.section]["id"]), callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        self.LoadActu()
                    }
                    else {
                        SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
                    }
                });
                
            }
            
            cell.tapped_delete = { [unowned self] (selectedCell, Newcontent) -> Void in
                let path = tableView.indexPathForRow(at: selectedCell.center)!
                //let selectedItem = self.actu[path.section]["content"]
                
                self.param["access-token"] = sharedInstance.header["access-token"]
                self.param["client"] = sharedInstance.header["client"]
                self.param["uid"] = sharedInstance.header["uid"]
                
                self.request.request(type: "DELETE", param: self.param, add: "news/" + String(describing: self.actu[path.section]["id"]) , callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        //self.refreshActu()
                        self.LoadActu()
                        
                    }
                    else {
                        SCLAlertView().showError("Erreur info", subTitle: "Une erreur est survenue")
                    }
                });
                
            }
            
            let datefinale = String(describing: actu[indexPath.section]["updated_at"])
            //        cell.textLabel!.text = String(asso_list["response"][indexPath.row]["name"])
            var title = ""
            title = String(describing: actu[indexPath.section]["volunteer_name"]) + " a publié sur le mur de " + String(describing: actu[indexPath.section]["group_name"])
            var from = ""
            if actu[indexPath.section]["volunteer_id"] == user["id"] {
                from = "true"
            }
            else {
                from = "false"
            }
            
            cell.setCell(NameLabel: title,DateLabel: datefinale, imageName: define.path_picture + String(describing: actu[indexPath.section]["volunteer_thumb_path"]), content: String(describing: actu[indexPath.section]["content"]), from: from)
            return cell
        } else {
            let cell = eventsNewsList.dequeueReusableCell(withIdentifier: "commentactuevent", for: indexPath) as UITableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return actu.count
    }
    
    func showGallery() {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "galleryViewController") as! GalleryAssoViewController
        VC1.eventID = self.EventID
        VC1.rights = self.rights
        self.navigationController!.pushViewController(VC1, animated: true)
    }
    
    @IBAction func JoinEvent(_ sender: AnyObject) {
        let prive = String(describing: self.Event["private"])
        print("PRIVE = \(prive)")
        //quitter un event en tant que membre
        if(self.rights == "member"){
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]
            
            param["event_id"] = EventID
            let val = "guests/leave"
            request.request(type: "DELETE", param: param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    self.JoinEventBtn.image = UIImage(named: "event_not_joined")
                    self.rights = "null"
                    self.publishButton.isEnabled = false
                }
                else {
                    SCLAlertView().showError("Attention", subTitle: "une erreur est survenue...")
                }
            });
            
        }
            //empecher a l'host de quitter
        else if (self.rights == "host"){
            SCLAlertView().showError("Attention", subTitle: "Vous avez créé cet évènement \n Vous ne pouvez le quitter !")
        }
        else if (self.rights == "waiting"){
            if prive == "true" {
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false,
                    showCircularIcon: false
                )
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("oui") {
                    self.param["access-token"] = sharedInstance.header["access-token"]
                    self.param["client"] = sharedInstance.header["client"]
                    self.param["uid"] = sharedInstance.header["uid"]
                    self.param["event_id"] = self.EventID
                    self.request.request(type: "DELETE", param: self.param,add: "guests/unjoin", callback: {
                        (isOK, User)-> Void in
                        if(isOK){
                            if User["status"] == 200 {
                                let imageBtnWait = UIImage(named: "event_joined")
                                let newimage = self.resizeImage(image: imageBtnWait!, newWidth: 30)
                                self.JoinEventBtn.image = newimage
                                self.rights = "none"
                            }else {
                                SCLAlertView().showError("En attente", subTitle: String(describing: User["message"]))
                            }
                        }
                        else {
                            
                        }
                    });
                }
                alertView.addButton("non") {
                    
                }
                alertView.showError("Annuler", subTitle: "Souhaitez-vous annuler votre demande pour rejoindre cette association ?")
            }
        }
        else{//Rejoindre l'event (envoyer une demande à l'host)
            self.param["access-token"] = sharedInstance.header["access-token"]
            self.param["client"] = sharedInstance.header["client"]
            self.param["uid"] = sharedInstance.header["uid"]
            
            param["event_id"] = EventID
            let val = "guests/join"
            request.request(type: "POST", param: param,add: val, callback: {
                (isOK, User)-> Void in
                if(isOK){
                    if prive == "true" {
                        SCLAlertView().showTitle("Demande envoyé", // Title of view
                            subTitle: "Vous receverez une notification concernant le retour de l'association", // String of view
                            duration: 10.0, // Duration to show before closing automatically, default: 0.0
                            completeText: "ok", // Optional button value, default: ""
                            style: .success, // Styles - see below.
                            colorStyle: 0x22B573,
                            colorTextButton: 0xFFFFFF
                        )
                        let imageBtnWait = UIImage(named: "waiting")
                        let newimage = self.resizeImage(image: imageBtnWait!, newWidth: 30)
                        self.JoinEventBtn.image = newimage
                        self.rights = "waiting"
                    }
                    else {
                        let imageBtnWait = UIImage(named: "event_joined")
                        let newimage = self.resizeImage(image: imageBtnWait!, newWidth: 30)
                        self.JoinEventBtn.image = newimage
                        self.rights = "member"
                        self.publishButton.isEnabled = true
                    }
                }
                else {
                    SCLAlertView().showError("Attention", subTitle: "une erreur est survenue...")
                }
            });
        }
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(EventID)
        print("----------")
        eventsNewsList.addSubview(self.refreshControl)
        eventsNewsList.estimatedRowHeight = 159.0
        eventsNewsList.rowHeight = UITableViewAutomaticDimension
        eventsNewsList.register(UINib(nibName: "CustomCellActu", bundle: nil), forCellReuseIdentifier: "customcellactu")
        
        user = sharedInstance.volunteer["response"]
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(showGallery))
        self.imageEvent.isUserInteractionEnabled = true
        self.imageEvent.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func refresh() {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        
        let val = "events/" + EventID
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                //test currentEvent save
                currentEvent.currentEvent = User["response"]
                print(currentEvent.currentEvent["title"])
                self.rights = String(describing: User["response"]["rights"])
                self.Event = User["response"]
                self.navigationItem.title = String(describing: self.Event["title"])
                
                if (self.rights == "waiting"){
                    let imageBtnWait = UIImage(named: "waiting")
                    let newimage = self.resizeImage(image: imageBtnWait!, newWidth: 30)
                    self.JoinEventBtn.image = newimage
                    self.publishButton.isEnabled = false
                }
                else if(self.rights == "host" || self.rights == "member"){
                    self.JoinEventBtn.image = UIImage(named: "event_joined")
                }
                else {
                    self.publishButton.isEnabled = false
                }
                let val2 = "/events/" + self.EventID + "/main_picture"
                self.request.request(type: "GET", param: self.param,add: val2, callback: {
                    (isOK, User)-> Void in
                    if(isOK){
                        self.main_picture = define.path_picture + String(describing: User["response"]["picture_path"]["url"])
                        self.imageEvent.downloadedFrom(link: self.main_picture, contentMode: .scaleAspectFit)
                        self.LoadActu()
                    }
                    else {
                        
                    }
                });
                
                
                //self.tableViewAssoc.reloadData()
            }
            else {
                SCLAlertView().showError("Attention", subTitle: "une erreur est survenue...")
            }
        });
    }
    
    func LoadActu() {
        self.param["access-token"] = sharedInstance.header["access-token"]
        self.param["client"] = sharedInstance.header["client"]
        self.param["uid"] = sharedInstance.header["uid"]
        
        let val = "events/" + EventID + "/news"
        request.request(type: "GET", param: param,add: val, callback: {
            (isOK, User)-> Void in
            if(isOK){
                self.refreshControl.endRefreshing()
                self.actu = User["response"]
                self.eventsNewsList.reloadData()
            }
            else {
                print("erreure")
            }
        });
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(currentEvent.currentEvent["title"])
        self.refresh()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if(segue.identifier == "EventInfoVC"){
            let secondViewController = segue.destination as! InformationsEvent
            
            // set a variable in the second view controller with the String to pass
            
            secondViewController.Event = self.Event
            secondViewController.rights = self.rights
        }
        if(segue.identifier == "EventMembersVC"){
            let secondViewController = segue.destination as! MembersEventController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.EventID = String(describing: self.Event["id"])
            secondViewController.AssoID = String(describing: self.Event["assoc_id"])
            secondViewController.status = self.rights
        }
        if(segue.identifier == "gotopostfromevent"){
            let secondViewController = segue.destination as! PostStatutAssoController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.EventID = String(describing: self.Event["id"])
            secondViewController.from = "event"
            secondViewController.name = String(describing: self.Event["title"])
        }
        if(segue.identifier == "goToUpdateEvent"){
            let secondViewController = segue.destination as! UpdateEventController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.Event = self.Event
        }
        if(segue.identifier == "fromevent"){
            let secondViewController = segue.destination as! ManagePhotoController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.id_event = String(describing: self.Event["id"])
            secondViewController.from = "3"
            secondViewController.state = "true"
            
        }
        if(segue.identifier == "gotocommentfromevent"){
            let indexPath = eventsNewsList.indexPath(for: sender as! UITableViewCell)
            let secondViewController = segue.destination as! CommentActuController
            
            // set a variable in the second view controller with the String to pass
            secondViewController.IDnews = String(describing: actu[indexPath!.section]["id"])
            
        }
        
    }//goToInviteGuest
    
    
}
