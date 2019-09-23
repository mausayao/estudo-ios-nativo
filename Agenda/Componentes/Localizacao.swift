//
//  Localizacao.swift
//  Agenda
//
//  Created by Maurício de Freitas Sayão on 20/09/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import CoreLocation

class Localizacao: NSObject {
    
    func converteEnderecoEmCoordenadas(endereco: String, local: @escaping(_ local: CLPlacemark) -> Void) {
        let conversor = CLGeocoder()
        conversor.geocodeAddressString(endereco) { (listaLocalizacoes, error) in
            if let localizacao = listaLocalizacoes?.first {
                local(localizacao)
            }
        }
    }

}
