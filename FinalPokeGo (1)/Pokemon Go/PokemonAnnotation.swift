//
//  PokemonAnnotation.swift
//  Pokemon Go
//
//  Created by Ravula, Sravani on 4/11/19.
//  Copyright © 2019 Ravula, Sravani. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    
    init(coord: CLLocationCoordinate2D, pokemon:Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }

}
/*Create an object that contains pokestops*/

class PokeStop: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var pokeStop : PokeStop
    
    init(coord: CLLocationCoordinate2D, pokeStop:PokeStop) {
        self.coordinate = coord
        self.pokeStop = pokeStop
    }
    
}
