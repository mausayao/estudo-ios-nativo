//
//  Pino.swift
//  Agenda
//
//  Created by Maurício de Freitas Sayão on 24/09/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import MapKit

class Pino: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var icon: UIImage?
    var color: UIColor?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    

}
