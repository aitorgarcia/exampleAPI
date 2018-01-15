//
//  ViewController.swift
//  exampleAPI
//
//  Created by Aitor Garcia on 10/01/18.
//  Copyright © 2018 Aitor García Luiz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var mensajes = [Message]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var messageTF: UITextField!
    
    //Anade un nuevo mensaje al chat, recarga la tabla y vacia los campos
    @IBAction func sendButton(sender: AnyObject) {
        let username = usernameTF.text
        let message = messageTF.text
        
        let nuevoMensaje = Message(autor: username!, mensaje: message!, id: 0, fecha: "")
        
        guardarJSON(nuevoMensaje)
        sleep(1)
        usernameTF.text = ""
        messageTF.text = ""
        print("Boton send pulsado (se ha guardado el mensaje en la API).")
        tableView.reloadData()
    }
    
    //Recarga la tabla (por si estas con la tabal filtrada)
    @IBAction func reloadButton(sender: AnyObject) {
        mensajes.removeAll()
        sleep(1)
        cargarJSON()
        print("Boton reload pulsado.")
    }
    
    
    //Borra el chat y recarga la tabla.
    @IBAction func clearButton(sender: AnyObject) {
        borrarJSON()
        
        mensajes.removeAll()
        tableView.reloadData()
        print("Boton clear pulsado (se han borrado todos los mensajes de la API).")
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //No muestra el teclado al pulsar en cualquiera de los dos textfields
        usernameTF.inputView = UIView()
        messageTF.inputView = UIView()
        //Quita la opcion de autocorrector
        usernameTF.autocorrectionType = .No
        messageTF.autocorrectionType = .No
        
        cargarJSON()
        
        sleep(1)
        tableView.reloadData()
    }
    
    
    
    
    //POST: GUARDA UN MENSAJE EN LA API
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
        
      
        let task = session.dataTaskWithRequest(request, completionHandler: {data,response, error -> Void in
        
            self.mensajes.removeAll()
            self.cargarJSON()
            //self.tableView.reloadData()
        
        })
        task.resume()
        self.tableView.reloadData()
    }


    
    
    //DELETE: BORRA TODA LA API
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
            // Leemos el JSON
            do {
                if NSString(data:data!, encoding: NSUTF8StringEncoding) != nil {
                    
                    //Extrayendo datos del JSON
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [[String: AnyObject]]
                    
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
    
    
    
    //GET: CARGA TODA LA API
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
    
    
    
    //GET: BORRA UN MENSAJE DE LA API
    func borrarMensajeJSON(id: String){
        // Datos de la conexion con la API
        let api : String = "http://roxy-hana.com:8080/api/board/delete/" + id
        let url = NSURL(string: api)!
        let session = NSURLSession.sharedSession()
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            // Leemos el JSON
            do {
                if NSString(data:data!, encoding: NSUTF8StringEncoding) != nil {
                    
                    //Extrayendo datos del JSON
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [[String: AnyObject]]
                    
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
        //mensajes.removeAll()
        //tableView.reloadData()
    }

    
    
    //GET: CARGA A PARTIR DE UN MENSAJE DE LA API
    func cargarAPartirDeUnMensajeJSON(id : String){
        // Datos de la conexion con la API
        let api : String = "http://roxy-hana.com:8080/api/board/news/" + id
        let url = NSURL(string: api)!
        //let url = NSURL(string: "http://roxy-hana.com:8080/api/board/" + id)!
        let session = NSURLSession.sharedSession()
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response.")
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
    
    

    
    
    //Boton de la celda para eliminar mensaje
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete    ."/*"✘    ."*/){ action, index in
            
            do{
                try managedContext.save()
                print(index.row)
                
                let idAPI : String = "\(self.mensajes[index.row].id)"
                print(idAPI)
                
                self.mensajes.removeAll()
                
                self.tableView.reloadData()
        
                self.borrarMensajeJSON(idAPI)
                sleep(1)
                self.tableView.reloadData()
            
            } catch {
                print("Error al eliminar el mensaje")
            }
        }
        delete.backgroundColor? = UIColor.redColor().colorWithAlphaComponent(0.3)
        
        
        let show = UITableViewRowAction(style: .Normal, title: "Show"/*"\u{2B07}"*/){ action, index in
            
            let idAPI : String = "\(self.mensajes[index.row].id)"
            print(idAPI)
            self.mensajes.removeAll()
            self.tableView.reloadData()
            self.cargarAPartirDeUnMensajeJSON(idAPI)
            sleep(1)
            self.tableView.reloadData()
        }
        show.backgroundColor? = UIColor.lightGrayColor()
        
        
        
        
        //self.mensajes.removeAll()
        return [delete, show]
    }
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! TableViewCell
        cell.usernameLabel.text = mensajes[indexPath.row].autor
        cell.messageLabel.text = mensajes[indexPath.row].mensaje
        
        //Pasa la fecha de String a NSDate
        let dateString = mensajes[indexPath.row].fecha
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        let dateFromString = dateFormatter2.dateFromString(dateString)
        
        //Pasa la fecha de NSDate a String
        let date = dateFromString
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let stringDate = dateFormatter.stringFromDate(date!)
        
        cell.dateLabel.text = stringDate
        
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
}

