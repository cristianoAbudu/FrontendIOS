//
//  ColaboradorDTO.swift
//  FrontendIOS
//
//  Created by Jovem Tranquilão on 02/08/23.
//

import Foundation


struct ColaboradorDTO : Decodable {
    var id : Double
        
    var nome : String
        
    var senha : String
        
    var score : String
        
    var chefe : ColaboradorChefeDTO
}

struct ColaboradorChefeDTO : Decodable {
    var id : Double
        
    var nome : String
        
    var senha : String
        
    var score : String
        
}

