//
//  Notificacoes.swift
//  Agenda
//
//  Created by Maurício de Freitas Sayão on 22/09/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

class Notificacoes: NSObject {
    
    func exibeNotificacao(dicionarioDeMedia: Dictionary<String, Any>) -> UIAlertController? {
        if let media = dicionarioDeMedia["media"] as? String {
            let alert = UIAlertController(title: "Atenção", message: "Média dos alunos são \(media)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default , handler: nil)
            
            alert.addAction(action)
            
            return alert
        }
        
        
        return nil
    }
    
}
