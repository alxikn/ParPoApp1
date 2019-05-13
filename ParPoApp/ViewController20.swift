//
//  ViewController20.swift
//  ParPoApp
//
//  Created by mac on 10/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ViewController20: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var refPrds: DatabaseReference!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtCiudad: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var tblPrds: UITableView!
    
  
    
    
    var PrdsList = [PrdModel]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Prd = PrdsList[indexPath.row]
        print(Prd.id!)
        let alertController = UIAlertController(title:Prd.Prd, message:"Give me values to update Vote", preferredStyle:.alert)
        
        let updateAction =  UIAlertAction(title: "Update", style:.default){(_) in
            
            //Checar el Id que no almacena los datos
            let id = Prd.id
            
            let Prd = alertController.textFields?[0].text
            let Ciudad = alertController.textFields?[1].text
            
            self.updatePri(id: id!, Prd: Prd!, Ciudad: Ciudad!)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style:.default){(_) in
            self.deletePan(id: Prd.id!)
        }
        
        alertController.addTextField{(textField) in textField.text = Prd.Prd
            
        }
        
        alertController.addTextField{(textField) in textField.text = Prd.Ciudad
            
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated:true, completion: nil)
    }
    
    func updatePri(id: String, Prd: String, Ciudad: String){
        let Prd = ["id": id, "PrdName": Prd, "PrdCiudad": Ciudad]
        
        refPrds.child(id).setValue(Prd)
        labelMessage.text = "Vote Updated" //Prd
        listPrds()
    }
    
    func deletePan(id:String){
        refPrds.child(id).setValue(nil)
        listPrds()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PrdsList.count
    }
    
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! TableViewCell20
        
        let Prds: PrdModel
        
        Prds = PrdsList[indexPath.row]
        
        cell.lblRname.text = Prds.Prd
        cell.lblRCiudad.text = Prds.Ciudad
       
        
        return cell
    }
    
    
    
    
    @IBAction func ButtonAddPrd(_ sender: UIButton) {
    
    
        
        //@IBAction func ButtonAddInstrument(_ sender: UIButton) {
        addPrds()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        refPrds = Database.database().reference().child("Prds");
        listPrds()
    }
    func listPrds(){
        refPrds.observe(DataEventType.value, with:{(snapshot) in
            if snapshot.childrenCount>=0{
                self.PrdsList.removeAll()
                
                for Prds in snapshot.children.allObjects as![DataSnapshot]{
                    let PrdObject = Prds.value as? [String: AnyObject]
                    let PrdName = PrdObject?["PrdName"]
                    let PrdCiudad = PrdObject?["PrdCiudad"]
                    let PrdId = PrdObject?["id"]
                    
                    let Prd = PrdModel(id: PrdId as! String?, Prd: PrdName as! String?, Ciudad: PrdCiudad as! String?)
                    self.PrdsList.append(Prd)
                }
                
                self.tblPrds.reloadData()
            }
        })
    }
    
    func addPrds(){
        let key = refPrds.childByAutoId().key
        
        let Prds = ["id":key,"PrdName": txtNombre.text! as String,"PrdCiudad": txtCiudad.text! as String]
        
        refPrds.child(key!).setValue(Prds)
        
        labelMessage.text = "Vote Added"
        listPrds()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
