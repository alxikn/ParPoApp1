//
//  ViewController10.swift
//  ParPoApp
//
//  Created by mac on 10/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ViewController10: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var refPris: DatabaseReference!
    
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtCiudad: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var tblPris: UITableView!
    
    
    
    
    var PrisList = [PriModel]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Pri = PrisList[indexPath.row]
        print(Pri.id!)
        let alertController = UIAlertController(title:Pri.Pri, message:"Give me values to update Vote", preferredStyle:.alert)
        
        let updateAction =  UIAlertAction(title: "Update", style:.default){(_) in
            
            
            let id = Pri.id
            
            let Pri = alertController.textFields?[0].text
            let Ciudad = alertController.textFields?[1].text
            
            self.updatePri(id: id!, Pri: Pri!, Ciudad: Ciudad!)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style:.default){(_) in
            self.deletePan(id: Pri.id!)
        }
        
        alertController.addTextField{(textField) in textField.text = Pri.Pri
            
        }
        
        alertController.addTextField{(textField) in textField.text = Pri.Ciudad
            
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated:true, completion: nil)
    }
    
    func updatePri(id: String, Pri: String, Ciudad: String){
        let Pri = ["id": id, "PriName": Pri, "PriCiudad": Ciudad]
        
        refPris.child(id).setValue(Pri)
        labelMessage.text = "Vote Updated" //Pri
        listPris()
    }
    
    func deletePan(id:String){
        refPris.child(id).setValue(nil)
        listPris()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PrisList.count
    }
    
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! TableViewCell10
        
        let Pris: PriModel
        
        Pris = PrisList[indexPath.row]
        
        cell.lblPri.text = Pris.Pri
        cell.lblVote.text = Pris.Ciudad
        
        return cell
    }
    
    
    
    @IBAction func ButtonAddVote(_ sender: UIButton) {
    
    
        //@IBAction func ButtonAddvote(_ sender: UIButton) {
        addPris()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        refPris = Database.database().reference().child("Pris");
        listPris()
    }
    func listPris(){
        refPris.observe(DataEventType.value, with:{(snapshot) in
            if snapshot.childrenCount>=0{
                self.PrisList.removeAll()
                
                for Pris in snapshot.children.allObjects as![DataSnapshot]{
                    let PriObject = Pris.value as? [String: AnyObject]
                    let PriName = PriObject?["PriName"]
                    let PriCiudad = PriObject?["PriCiudad"]
                    let PriId = PriObject?["id"]
                    
                    let Pri = PriModel(id: PriId as! String?, Pri: PriName as! String?, Ciudad: PriCiudad as! String?)
                    self.PrisList.append(Pri)
                }
                
                self.tblPris.reloadData()
            }
        })
    }
    
    func addPris(){
        let key = refPris.childByAutoId().key
        
        let Pris = ["id":key,"PriName": txtNombre.text! as String,"PriCiudad": txtCiudad.text! as String]
        
        refPris.child(key!).setValue(Pris)
        
        labelMessage.text = "Vote Added"
        listPris()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
