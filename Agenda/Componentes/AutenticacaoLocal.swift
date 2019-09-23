//
//  AutenticacaoLocal.swift
//  Agenda
//
//  Created by Maurício de Freitas Sayão on 23/09/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import LocalAuthentication

class AutenticacaoLocal: NSObject {
    
    var error: NSError?
    
    func autorizaUsuario(completion: @escaping (_ logado:Bool) -> Void) {
        let contexto = LAContext()
        
        if contexto.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error){
            contexto.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "É nescessário autenticação para apagar o aluno.") { (resposta, error) in
                if error == nil{
                     completion(resposta)
                }
            }
        }
    }

}
