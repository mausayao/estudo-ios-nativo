//
//  MenuOpcoes.swift
//  Agenda
//
//  Created by Maurício de Freitas Sayão on 15/09/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

enum MenuActionSheetAlunos {
    case sms
    case ligacao
    case waze
    case mapa
}

class MenuOpcoesAlunos: NSObject {
    
    func configuraOpcoesAluno(completion: @escaping(_ opcao: MenuActionSheetAlunos) -> Void) -> UIAlertController {
        
        let menu = UIAlertController(title: "Atenção", message: "Escolha uma da opções abaixo", preferredStyle: .actionSheet)
        
        let sms = UIAlertAction(title:"SMS", style: .default){(acao) in
            completion(.sms)
        }
        
        menu.addAction(sms)
        
        let ligacao = UIAlertAction(title: "ligar", style: .default) { (acao) in
            completion(.ligacao)
        }
        
        menu.addAction(ligacao)
        
        let waze = UIAlertAction(title: "Localizar no Waze", style: .default) { (acao) in
            completion(.waze)
        }
        
        menu.addAction(waze)
        
        let mapa = UIAlertAction(title: "Mapa", style: .default) { (acao) in
            completion(.mapa)
        }
        
        menu.addAction(mapa)
        
        let cancelar = UIAlertAction(title: "cancelar", style: .cancel, handler: nil)
        
        menu.addAction(cancelar)
        
        return menu
        
    }
    
}
