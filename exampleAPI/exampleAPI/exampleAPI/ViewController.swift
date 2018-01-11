//
//  ViewController.swift
//  exampleAPI
//
//  Created by Aitor Garcia on 10/01/18.
//  Copyright © 2018 Aitor García Luiz. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var mensajes = [Message]()
    //var mensajes: [NSManagedObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var messageTF: UITextField!
    
    //Anade un nuevo mensaje al chat, recarga la tabla y vacia los campos
    @IBAction func sendButton(sender: AnyObject) {
        let username = usernameTF.text
        let message = messageTF.text
        
        let nuevoMensaje = Message(autor: username!, mensaje: message!, id: 0, fecha: "")
        //mensajes += [nuevoMensaje]
        
        guardarJSON(nuevoMensaje)
        
        //tableView.reloadData()
        usernameTF.text = ""
        messageTF.text = ""
        //print("Boton send pulsado.")
    }
    
    
    //Borra el chat y recarga la tabla
    @IBAction func clearButton(sender: AnyObject) {
        
      borrarJSON()
        
        mensajes.removeAll()
        tableView.reloadData()
        print("Boton clear pulsado.")
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //No muestra el teclado al pulsar en cualquiera de los dos textfields
        usernameTF.inputView = UIView()
        messageTF.inputView = UIView()
        
        cargarJSON()
    }
    
    func guardarJSON(nuevoMensaje: Message){
        // Datos de la conexion con la API
        let url = NSURL(string: "http://roxy-hana.com:8080/api/board/new")!
        let session = NSURLSession.sharedSession()
        
        
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        
        var data = [String: AnyObject]()
        data["author"] = nuevoMensaje.autor
        data["message"] = nuevoMensaje.mensaje
        
         request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(data , options: [])
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
      
        let task = session.dataTaskWithRequest(request, completionHandler: {data,response, error -> Void in print("OK")
            
            
        self.cargarJSON()
        
        })
        task.resume()
        
    }

    
    func borrarJSON(){
        // Datos de la conexion con la API
        let url = NSURL(string: "http://roxy-hana.com:8080/api/board/clean")!
        let session = NSURLSession.sharedSession()
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            do {
                if NSString(data:data!, encoding: NSUTF8StringEncoding) != nil {
                    
                    //Extrayendo datos del JSON
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [[String: AnyObject]]
                    
                    //pruebas para cargar con un array
                    for msg in json {
                        let autor = msg["author"] as! String
                        let mensaje = msg["message"] as! String
                        let id = msg["id"] as! Int
                        let fecha = msg["date"] as! String
                        self.mensajes.append(Message(autor: autor, mensaje: mensaje, id: id, fecha: fecha))
                        
                    }
                    self.tableView.reloadData()
                }
            } catch let error as NSError{
                print("Error al cargar: \(error.localizedDescription)")
            }
        }).resume()
    }
    
    func cargarJSON() {
        // Datos de la conexion con la API
        let url = NSURL(string: "http://roxy-hana.com:8080/api/board/")!
        let session = NSURLSession.sharedSession()
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
                }
            
            // Read the JSON
            do {
                if NSString(data:data!, encoding: NSUTF8StringEncoding) != nil {
                    
                    //Extrayendo datos del JSON
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [[String: AnyObject]]
                    
                    //pruebas para cargar con un array
                    for msg in json {
                        let autor = msg["author"] as! String
                        let mensaje = msg["message"] as! String
                        let id = msg["id"] as! Int
                        let fecha = msg["date"] as! String
                        self.mensajes.append(Message(autor: autor, mensaje: mensaje, id: id, fecha: fecha))

                    }
                    self.tableView.reloadData()
                }
            } catch let error as NSError{
                print("Error al cargar: \(error.localizedDescription)")
            }
        }).resume()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! TableViewCell
        cell.usernameLabel.text = mensajes[indexPath.row].autor
        cell.messageLabel.text = mensajes[indexPath.row].mensaje
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mensajes.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func cargarDatosTabla(){
     
     //Ejemplos para comprobar que funcionaba bien
     /*let m1 = Message(autor: "Aitor", mensaje: "Hola, que tal")
     let m2 = Message(autor: "Roxy", mensaje: "Buenas, muy bien, y tu")
     let m3 = Message(autor: "Aitor", mensaje: "Mal, quiero puto morirme")
     let m4 = Message(autor: "Roxy", mensaje: "I know that feel")
     mensajes += [m1,m2,m3,m4]*/
     
     if let array = NSKeyedUnarchiver.unarchiveObjectWithFile(Message.messageURL!.path!) as? [Message]{
     self.mensajes += array
     }else{
     print("Error al cargar los datos")
     let m1 = Message(autor: "Aitor", mensaje: "Hola, que tal")
     let m2 = Message(autor: "Roxy", mensaje: "Buenas, muy bien, y tu")
     let m3 = Message(autor: "Aitor", mensaje: "Mal, quiero puto morirme")
     let m4 = Message(autor: "Roxy", mensaje: "I know that feel")
     mensajes += [m1,m2,m3,m4]
     }
     }*/
    
    /*
     func guardarDatos(){
     let exito = NSKeyedArchiver.archiveRootObject(self.mensajes, toFile: Message.messageURL!.path!)
     if !exito{
     print("Error en la carga del archivo...")
     }
     }*/
    
    
}

