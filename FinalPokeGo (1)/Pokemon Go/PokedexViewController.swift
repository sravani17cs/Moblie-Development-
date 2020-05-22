//
//  PokedexViewController.swift
//  Pokemon Go
//
//  Created by Ravula, Sravani on 4/9/19.
//  Copyright © 2019 Ravula, Sravani. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDataSource,
    UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var caughtPokemon : [Pokemon] = []
    var uncaughtPokemon : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caughtPokemon = getCaughtPokemon(caught: true)
        uncaughtPokemon = getCaughtPokemon(caught: false)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Caught"
        } else {
            return "Uncaught"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return caughtPokemon.count
        } else {
            return uncaughtPokemon.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        var pokemon : Pokemon
        if indexPath.section == 0 {
            pokemon = caughtPokemon[indexPath.row]
        } else {
            pokemon = uncaughtPokemon[indexPath.row]
        }
        
        if (pokemon.name == "pokeStop") {
            cell.textLabel?.text = "Pokeballs"
            cell.textLabel?.text! += "   " + String(pokemon.count)
            cell.imageView?.image = UIImage(named: "pokeball")
            
//            cell.detailTextLabel?.text = String(pokemon.count)
            
            return cell
        } else {
            cell.textLabel?.text = pokemon.name
            cell.textLabel?.text! += "   " + String(pokemon.count)
            if let imageName = pokemon.imageName {
                cell.imageView?.image = UIImage(named: imageName)
            }
        
//            cell.detailTextLabel?.text = String(pokemon.count)
        
            return cell
        }
    }
    
    @IBAction func CancleTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
