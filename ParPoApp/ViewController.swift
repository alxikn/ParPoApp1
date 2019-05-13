//
//  ViewController.swift
//  ParPoApp
//
//  Created by mac on 10/05/19.
//  Copyright © 2019 mac. All rights reserved.
//



import UIKit
import FirebaseDatabase
import Firebase

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var refPans: DatabaseReference!
    
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtCiudad: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var tblPans: UITableView!
    

    
    var PansList = [PanModel]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Pan = PansList[indexPath.row]
        print(Pan.id!)
        let alertController = UIAlertController(title:Pan.Pan, message:"Give me values to update Vote", preferredStyle:.alert)
        
        let updateAction =  UIAlertAction(title: "Update", style:.default){(_) in
            
            //Checar el Id que no almacena los datos
            let id = Pan.id
            
            let Pan = alertController.textFields?[0].text
            let Ciudad = alertController.textFields?[1].text
            
            self.updatePan(id: id!, Pan: Pan!, Ciudad: Ciudad!)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style:.default){(_) in
            self.deletePan(id: Pan.id!)
        }
        
        alertController.addTextField{(textField) in textField.text = Pan.Pan
            
        }
        
        alertController.addTextField{(textField) in textField.text = Pan.Ciudad
            
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated:true, completion: nil)
    }
    
    func updatePan(id: String, Pan: String, Ciudad: String){
        let Pan = ["id": id, "PanName": Pan, "PanCiudad": Ciudad]
        
        refPans.child(id).setValue(Pan)
        labelMessage.text = "Vote Updated" //Pan
        listPans()
    }
    
    func deletePan(id:String){
        refPans.child(id).setValue(nil)
        listPans()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PansList.count
    }
    
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let Pans: PanModel
        
        Pans = PansList[indexPath.row]
        
        cell.lblNombre.text = Pans.Pan
        cell.lblCiudad.text = Pans.Ciudad
        
        return cell
    }
    
 
        
    @IBAction func ButtonAddVote(_ sender: UIButton) {
    
    //@IBAction func ButtonAdd {
        addPan()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        refPans = Database.database().reference().child("Pan");
        listPans()
    }
    func listPans(){
        refPans.observe(DataEventType.value, with:{(snapshot) in
            if snapshot.childrenCount>=0{
                self.PansList.removeAll()
                
                for Pans in snapshot.children.allObjects as![DataSnapshot]{
                    let PanObject = Pans.value as? [String: AnyObject]
                    let PanName = PanObject?["PanName"]
                    let PanCiudad = PanObject?["PanCiudad"]
                    let PanId = PanObject?["id"]
                    
                    let Pan = PanModel(id: PanId as! String?, Pan: PanName as! String?, Ciudad: PanCiudad as! String?)
                    self.PansList.append(Pan)
                }
                
                self.tblPans.reloadData()
            }
        })
    }
    
    func addPan(){
        let key = refPans.childByAutoId().key
        
        let Pans = ["id":key,"PanName": txtNombre.text! as String,"PanCiudad": txtCiudad.text! as String]
        
        refPans.child(key!).setValue(Pans)
        
        labelMessage.text = "Vote Added"
        listPans()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
