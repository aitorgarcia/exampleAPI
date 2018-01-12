//
//  Message.swift
//  exampleAPI
//
//  Created by Aitor Garcia on 11/01/18.
//  Copyright © 2018 Aitor García Luiz. All rights reserved.
//

import UIKit

class Message{
    
    var autor: String
    var mensaje: String
    var id: Int
    var fecha : String
    
    
    init(autor: String, mensaje: String, id: Int, fecha: String){
        self.autor = autor
        self.mensaje = mensaje
        self.id = id
        self.fecha = fecha
    }
}
