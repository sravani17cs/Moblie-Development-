//
//  MapViewController.swift
//  Pokemon Go
//
//  Created by Ravula, Sravani on 4/9/19.
//  Copyright © 2019 Ravula, Sravani. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapview: MKMapView!
    var manager = CLLocationManager()
    
    var updateCounter = 0
    var pokemonCount = 0
    var pokeStopCounter = 0
    var pokeBallCount = 10;
    var pokemons : [Pokemon] =  []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getPokemon()
        
        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            //The user has given permission to use there current lcoation setup the application
            
        }else {
            //ask the user for permission
            manager.requestWhenInUseAuthorization()
        }
    }
    /*Check if the client has alowed us to use there current location*/
    func locationManager (_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse{
            setUpGame() //start the game if the user accepts
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(updateCounter < 3){
            if let center = manager.location?.coordinate{
                let region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
                mapview.setRegion(region, animated: false)
            }
            updateCounter+=1 //update
        } else {
            manager.stopUpdatingLocation()
        }
        
        
    }
    
    func setUpGame(){
        mapview.showsUserLocation=true
        manager.startUpdatingLocation()
        mapview.delegate=self
        
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { (timer) in
            if (self.pokemonCount == 2000) {
                return
            }
            self.pokemonCount += 1
            if let playerLocation = self.manager.location?.coordinate {
                var pokemonCoordinate = playerLocation
                pokemonCoordinate.latitude += (Double.random(in: 0...200) - 100.0) / 5000.0
                pokemonCoordinate.longitude += (Double.random(in: 0...200) - 100.0) / 5000.0
                var pokeStopCoordinate = playerLocation
                pokeStopCoordinate.latitude += (Double.random(in: 0...200) - 100.0) / 2500.0
                pokeStopCoordinate.longitude += (Double.random(in: 0...200) - 100.0) / 2500.0
                if let pokemon = self.pokemons.randomElement() {
                    if (pokemon.name != "pokeStop"){
                        let annotation = PokemonAnnotation(coord: pokemonCoordinate, pokemon: pokemon)
                        self.mapview.addAnnotation(annotation)
                    } else if (self.pokeStopCounter < 50) {
                        let annotation = PokemonAnnotation(coord: pokemonCoordinate, pokemon: pokemon)
                        self.mapview.addAnnotation(annotation)
                    }
                }
                
//                let annotation = PokeStop(coord: pokemonCoordinate, pokeStop: PokeStop)
//                    self.mapview.addAnnotation(annotation)
                
            }
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoview = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if annotation is MKUserLocation{
            annoview.image = UIImage(named: "player")
        } else{
            if let pokemonAnnotation = annotation as? PokemonAnnotation {
                if let imageName = pokemonAnnotation.pokemon.imageName {
                    annoview.image = UIImage(named: imageName)
                }
            }
        }
        var frame = annoview.frame
        frame.size.height = 50.0
        frame.size.width =  50.0
        annoview.frame = frame
        
        return annoview
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true) //anmaite
        if(view.annotation is MKUserLocation){
            //THIS IS THE USER
        } else { //they've tapped on a pokemon
            if let center = manager.location?.coordinate {
                if let pokeCenter = view.annotation?.coordinate {
                    let region = MKCoordinateRegion(center: pokeCenter, latitudinalMeters: 200, longitudinalMeters: 200)
                    mapView.setRegion(region, animated: false)
                    if let pokeAnnotation = view.annotation as?
                        PokemonAnnotation {
                        if let pokemonName = pokeAnnotation.pokemon.name {
                            if mapView.visibleMapRect.contains(MKMapPoint(center)) {
                                if (pokemonName == "pokeStop") {
                                    let alertVC = UIAlertController(title: "Pokestop Visted", message: "You obtained 5 pokeballs" , preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alertVC.addAction(okAction)
                                    present(alertVC, animated: true, completion: nil)
                                    pokeBallCount += 5
                                    pokeAnnotation.pokemon.count = Int16(pokeBallCount)
                                    return;
                                } else if (pokeBallCount == 0) {
                                    let alertVC = UIAlertController(title: "No Pokeballs", message: "You have no pokeballs. You need them to catch pokemon." , preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alertVC.addAction(okAction)
                                    present(alertVC, animated: true, completion: nil)
                                    return;
                                }
                                
                                pokeAnnotation.pokemon.caught = true
                                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                                
                                
                                let alertVC = UIAlertController(title: "Congrats", message: "You caught \(pokemonName)" , preferredStyle: .alert)
                                pokeAnnotation.pokemon.count += 1
                                self.mapview.removeAnnotation(pokeAnnotation)
                                let pokeDexAction = UIAlertAction(title:
                                    "PokeDex", style: .default)
                                { (action) in
                                    self.performSegue(withIdentifier: "moveToPokedex", sender: nil)
                                }
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertVC.addAction(pokeDexAction)
                                alertVC.addAction(okAction)
                                present(alertVC, animated: true, completion: nil)
                                self.pokemonCount -= 1
                                pokeBallCount -= 1
                            } else {
                                //print("OOPS You're too far away from the pokemon... Thats too bad")
                                //TOO FAR
                                let alertVC = UIAlertController(title: "Too Far Away", message: "Move closer to interact with" , preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertVC.addAction(okAction)
                                present(alertVC, animated: true, completion: nil)
                                
                                
                            }
                        }
                    }
                }
            }
        }
    }
    @IBAction func centerTapped(_ sender: Any) {
        if let center = manager.location?.coordinate{
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
            mapview.setRegion(region, animated: true)
        }
    }
}
