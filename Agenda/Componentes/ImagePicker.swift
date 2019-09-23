//
//  ImagePicker.swift
//  Agenda
//
//  Created by Maurício de Freitas Sayão on 04/09/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

enum MenuOpcoes {
    case camera
    case biblioteca
}

protocol ImagePickerFotoSelecionada {
    func imagePickerFotoSelecionada(_ foto: UIImage)
}

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: ImagePickerFotoSelecionada?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let foto = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        delegate?.imagePickerFotoSelecionada(foto)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func menuDeOpcoes(completion: @escaping(_ opcao: MenuOpcoes) -> Void) -> UIAlertController {
        let menu =  UIAlertController(title: "Atenção", message: "Escolha uma das opções", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Tirar foto", style: .default) { (acao) in
            completion(.camera)
        }
        
        menu.addAction(camera)
        
        let biblioteca = UIAlertAction(title: "Biblioteca", style: .default) { (acao) in
           completion(.biblioteca)
        }
        
        let cancelar =  UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        menu.addAction(cancelar)
        
        menu.addAction(biblioteca)
        
        return menu
    }

}
