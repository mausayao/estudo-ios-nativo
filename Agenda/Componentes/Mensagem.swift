//
//  Mensagem.swift
//  Agenda
//
//  Created by Maurício de Freitas Sayão on 15/09/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import MessageUI

class Mensagem: NSObject, MFMessageComposeViewControllerDelegate {
    
    // MARK: configura sms
    func configuraSms(_ aluno: Aluno) -> MFMessageComposeViewController? {
        
        if MFMessageComposeViewController.canSendText() {
            let componenteMensagem = MFMessageComposeViewController()
            guard let numero = aluno.telefone else {return componenteMensagem}
            componenteMensagem.recipients = [numero]
            componenteMensagem.messageComposeDelegate = self

            return componenteMensagem
        }
        
        return nil
    }
    
    // MARK: MessageComposeDelegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    

}
