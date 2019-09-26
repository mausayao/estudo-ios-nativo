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
    lazy var localizacao = Localizacao()
    
    //MARK: - Variaveis
    var aluno: Aluno?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = getTitle()
        self.localizacaoInicial()
        self.localizaAluno()
        mapa.delegate = localizacao
    }
    
    //MARK: - Métodos
    
    func localizaAluno() {
        if let aluno = aluno {
            Localizacao().converteEnderecoEmCoordenadas(endereco: aluno.endereco!) { (localizacao) in
                let pino = Localizacao().configuraPino(titulo: aluno.nome!, localizacao: localizacao, color: nil, icon: nil)
                
                self.mapa.addAnnotation(pino)
            }
        }
    }
    
    func localizacaoInicial() {
        Localizacao().converteEnderecoEmCoordenadas(endereco: "Caelum - São Pualo") { (localizacao) in
            let pino = Localizacao().configuraPino(titulo: "Caelum", localizacao: localizacao, color: UIColor.black, icon: UIImage(named: "caelum"))
            let regiao = MKCoordinateRegion(center: pino.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            self.mapa.setRegion(regiao, animated: true)
            self.mapa.addAnnotation(pino)
        }
    }
    
   
    
    func getTitle() -> String {
        return "Localizar Aluno"
    }
    
}
