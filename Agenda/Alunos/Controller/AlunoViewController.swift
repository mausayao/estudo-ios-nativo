//
//  AlunoViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit
import CoreData

class AlunoViewController: UIViewController, ImagePickerFotoSelecionada {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var viewImagemAluno: UIView!
    @IBOutlet weak var imageAluno: UIImageView!
    @IBOutlet weak var buttonFoto: UIButton!
    @IBOutlet weak var scrollViewPrincipal: UIScrollView!
    
    @IBOutlet weak var textFieldNome: UITextField!
    @IBOutlet weak var textFieldEndereco: UITextField!
    @IBOutlet weak var textFieldTelefone: UITextField!
    @IBOutlet weak var textFieldSite: UITextField!
    @IBOutlet weak var textFieldNota: UITextField!
    
    let imagePicker = ImagePicker()
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    var alunoSelecionado: Aluno?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arredondaView()
        NotificationCenter.default.addObserver(self, selector: #selector(aumentarScrollView(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.setUp()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Métodos
    
    func setUp() {
        self.imagePicker.delegate = self
        
        guard let aluno = alunoSelecionado else { return }
        textFieldNome.text = aluno.nome
        textFieldNota.text = String(aluno.nota)
        textFieldSite.text = aluno.site
        textFieldEndereco.text = aluno.endereco
        textFieldTelefone.text = aluno.telefone
        imageAluno.image = aluno.imagem as? UIImage
    }
    
    func arredondaView() {
        self.viewImagemAluno.layer.cornerRadius = self.viewImagemAluno.frame.width / 2
        self.viewImagemAluno.layer.borderWidth = 1
        self.viewImagemAluno.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @objc func aumentarScrollView(_ notification:Notification) {
        self.scrollViewPrincipal.contentSize = CGSize(width: self.scrollViewPrincipal.frame.width, height: self.scrollViewPrincipal.frame.height + self.scrollViewPrincipal.frame.height/2)
    }
    
    // MARK: - IBActions
    
    func mostrarMultimidia(_ opcao: MenuOpcoes) {
        let multimidia = UIImagePickerController()
        multimidia.delegate = imagePicker
        if opcao == .camera && UIImagePickerController.isSourceTypeAvailable(.camera){
            multimidia.sourceType = .camera
        } else {
            multimidia.sourceType = .photoLibrary
        }
        
        self.present(multimidia, animated: true, completion: nil)
    }
    
    @IBAction func buttonFoto(_ sender: UIButton) {
        
        let menu = self.imagePicker.menuDeOpcoes { (opcao) in
            self.mostrarMultimidia(opcao)
        }
        
        self.present(menu, animated: true, completion: nil)
        
        
    }
    
    @IBAction func stepperNota(_ sender: UIStepper) {
        self.textFieldNota.text = "\(sender.value)"
    }
    
    func imagePickerFotoSelecionada(_ foto: UIImage) {
        imageAluno.image = foto
    }
    
    @IBAction func btSalvar(_ sender: UIButton) {
        if alunoSelecionado == nil{
            alunoSelecionado = Aluno(context: contexto)
        }
        alunoSelecionado?.endereco = textFieldEndereco.text
        alunoSelecionado?.nome = textFieldNome.text
        alunoSelecionado?.site = textFieldSite.text
        alunoSelecionado?.nota = (textFieldNota.text! as NSString).doubleValue
        alunoSelecionado?.imagem = imageAluno.image
        alunoSelecionado?.telefone = textFieldTelefone.text
        
        do {
            try contexto.save()
            navigationController?.popViewController(animated: true)
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
}
