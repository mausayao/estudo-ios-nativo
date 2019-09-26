//
//  Localizacao.swift
//  Agenda
//
//  Created by Maurício de Freitas Sayão on 20/09/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import MapKit

class Localizacao: NSObject, MKMapViewDelegate {
    
    func converteEnderecoEmCoordenadas(endereco: String, local: @escaping(_ local: CLPlacemark) -> Void) {
        let conversor = CLGeocoder()
        conversor.geocodeAddressString(endereco) { (listaLocalizacoes, error) in
            if let localizacao = listaLocalizacoes?.first {
                local(localizacao)
            }
        }
    }
    
    func configuraPino(titulo: String, localizacao: CLPlacemark, color: UIColor?, icon: UIImage?) -> Pino {
           let pino = Pino(coordinate: localizacao.location!.coordinate)
           pino.title = titulo
           pino.coordinate = localizacao.location!.coordinate
           pino.color = color
           pino.icon = icon
           
           return pino
       }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Pino {
            let annotationView = annotation as! Pino
            var pinoView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationView.title!) as? MKMarkerAnnotationView
            pinoView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationView.title!)
            
            pinoView?.annotation = annotationView
            pinoView?.glyphImage = annotationView.icon
            pinoView?.markerTintColor = annotationView.color
            
            return pinoView
        }
        return nil
    }

}
