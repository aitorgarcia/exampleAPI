//
//  Message.swift
//  exampleAPI
//
//  Created by Aitor Garcia on 11/01/18.
//  Copyright © 2018 Aitor García Luiz. All rights reserved.
//

import UIKit

class Message: NSObject, NSCoding{
    
    var autor: String
    var mensaje: String
    var id: Int
    var fecha : String
    
    static let directorio = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
    static let messageURL = directorio?.URLByAppendingPathComponent("listadoMensajes")
    
    
    init(autor: String, mensaje: String, id: Int, fecha: String){
        self.autor = autor
        self.mensaje = mensaje
        self.id = id
        self.fecha = fecha
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(autor, forKey: "author")
        aCoder.encodeObject(mensaje, forKey: "message")
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(fecha, forKey: "date")
    }
    
    required convenience init(coder aDecoder: NSCoder){
        let autor = aDecoder.decodeObjectForKey("author") as! String
        let mensaje = aDecoder.decodeObjectForKey("message") as! String
        let id = aDecoder.decodeObjectForKey("id") as! Int
        let fecha = aDecoder.decodeObjectForKey("date") as! String
        
        self.init(autor: autor, mensaje: mensaje, id: id, fecha: fecha)
    }
}
