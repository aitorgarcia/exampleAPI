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
    
    static let directorio = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
    static let messageURL = directorio?.URLByAppendingPathComponent("listadoMensajes")
    
    
    init(autor: String, mensaje: String){
        self.autor = autor
        self.mensaje = mensaje
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(autor, forKey: "author")
        aCoder.encodeObject(mensaje, forKey: "")
    }
    
    required convenience init(coder aDecoder: NSCoder){
        let autor = aDecoder.decodeObjectForKey("author") as! String
        let mensaje = aDecoder.decodeObjectForKey("message") as! String
        
        self.init(autor: autor, mensaje: mensaje)
    }
}
