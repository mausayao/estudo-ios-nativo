//
//  MapaViewController.swift
//  Agenda
//
//  Created by Maurício de Freitas Sayão on 22/09/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController {
    
    @IBOutlet weak var mapa: MKMapView!
    
    //MARK: - Variaveis
    var aluno: Aluno?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = getTitle()
        self.localizacaoInicial()
        self.localizaAluno()
    }
    
    //MARK: - Métodos
    
    func localizaAluno() {
        if let aluno = aluno {
            Localizacao().converteEnderecoEmCoordenadas(endereco: aluno.endereco!) { (localizacao) in
                let pino = self.configuraPino(titulo: aluno.nome!, localizacao: localizacao)
                
                self.mapa.addAnnotation(pino)
            }
        }
    }
    
    func localizacaoInicial() {
        Localizacao().converteEnderecoEmCoordenadas(endereco: "Caelum - São Pualo") { (localizacao) in
            let pino = self.configuraPino(titulo: "Caelum", localizacao: localizacao)
            let regiao = MKCoordinateRegion(center: pino.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            self.mapa.setRegion(regiao, animated: true)
            self.mapa.addAnnotation(pino)
        }
    }
    
    func configuraPino(titulo: String, localizacao: CLPlacemark) -> MKPointAnnotation {
        let pino = MKPointAnnotation()
        pino.title = titulo
        pino.coordinate = localizacao.location!.coordinate
        
        return pino
    }
    
    func getTitle() -> String {
        return "Localizar Aluno"
    }
    
}
