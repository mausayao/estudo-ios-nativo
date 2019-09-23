//
//  HomeTableViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    //MARK: - Variáveis
    
    let searchController = UISearchController(searchResultsController: nil)
    var gerenciadorDeResultado: NSFetchedResultsController<Aluno>?
    
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    var alunoViewController: AlunoViewController?
    var mensagem = Mensagem()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuraSearch()
        self.recuperarAlunos()
    }
    
    // MARK: - Métodos
    
    @IBAction func btCalculaMedia(_ sender: UIBarButtonItem) {
        guard let alunos = gerenciadorDeResultado?.fetchedObjects else { return  }
        
        CalculaMediaApi().calculaMediaGeralDosAlunos(alunos: alunos, sucesso: { (dicionario) in
            if let alerta = Notificacoes().exibeNotificacao(dicionarioDeMedia: dicionario) {
                self.present(alerta, animated: true, completion: nil)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            alunoViewController = segue.destination as! AlunoViewController
        }
    }
    
    func configuraSearch() {
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    func recuperarAlunos() {
        let pesquisarAluno: NSFetchRequest<Aluno> = Aluno.fetchRequest()
        let ordenaAluno = NSSortDescriptor(key: "nome", ascending: true)
        pesquisarAluno.sortDescriptors = [ordenaAluno]
        
        gerenciadorDeResultado = NSFetchedResultsController(fetchRequest: pesquisarAluno, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        gerenciadorDeResultado?.delegate = self
        
        do {
            try gerenciadorDeResultado?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    @objc func abrirMenuDeOpcoes(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            
            guard let aluno = gerenciadorDeResultado?.fetchedObjects![(longPress.view?.tag)!] else {return}
            
            let menu = MenuOpcoesAlunos().configuraOpcoesAluno(completion: {(opcao) in
                switch opcao {
                    
                case .sms:
                    if let componenteMensagem = self.mensagem.configuraSms(aluno) {
                        componenteMensagem.messageComposeDelegate = self.mensagem
                        self.present(componenteMensagem, animated: true, completion: nil)
                    }
                    break
                    
                case .ligacao:
                    guard let numero = aluno.telefone else {return}
                    if let url = URL(string: "tel://\(numero)"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    break
                case .waze:
                    if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
                        guard let endereco = aluno.endereco else { return }
                        Localizacao().converteEnderecoEmCoordenadas(endereco: endereco, local: { (localizacao) in
                            let latitude = String(describing: localizacao.location!.coordinate.latitude)
                            let longitude = String(describing: localizacao.location!.coordinate.longitude)
                            let url: String = "waze://??ll=\(latitude),\(longitude)&navigate=yes"
                            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                        })
                    }
                case .mapa:
                    let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapa") as! MapaViewController
                    
                    mapa.aluno = aluno
                    
                    self.navigationController?.pushViewController(mapa, animated: true)
                    
                    break
                }
            })
            self.present(menu, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contador = gerenciadorDeResultado?.fetchedObjects?.count else {
            return 0
        }
        return contador
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula-aluno", for: indexPath) as! HomeTableViewCell
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(abrirMenuDeOpcoes(_:)))
        guard let aluno = gerenciadorDeResultado?.fetchedObjects![indexPath.row] else {
            return cell
        }
        cell.configuraCelula(aluno)
        cell.addGestureRecognizer(longPress)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let alunoSelecionado = gerenciadorDeResultado?.fetchedObjects![indexPath.row] else {return}
            
            contexto.delete(alunoSelecionado)
            do {
                try contexto.save()
            } catch {
                print(error.localizedDescription)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let alunoSelecionado = gerenciadorDeResultado?.fetchedObjects![indexPath.row] else {
            return
        }
        
        alunoViewController?.alunoSelecionado = alunoSelecionado
    }
    
    // MARK: - FetcResultsDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let index = indexPath else {return}
            tableView.deleteRows(at: [index], with: .fade)
            break
        default:
            self.tableView.reloadData()
        }
    }
    
}
