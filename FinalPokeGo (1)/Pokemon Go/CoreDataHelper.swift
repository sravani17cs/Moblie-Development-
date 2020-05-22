//
//  CoreDataHelper.swift
//  Pokemon Go
//
//  Created by Ravula, Sravani on 4/11/19.
//  Copyright © 2019 Ravula, Sravani. All rights reserved.
//

import UIKit
import CoreData

func addPokemon() {
    createPokemon(name: "Bellsprout", imageName: "Bellsprout")
    createPokemon(name: "Mankey", imageName: "Mankey")
    createPokemon(name: "Pikachu", imageName: "Pikachu")
    createPokemon(name: "Dratini", imageName: "Dratini")
    createPokemon(name: "Squirtle", imageName: "Squirtle")
    createPokemon(name: "Snorlax", imageName: "Snorlax")
    createPokemon(name: "Zubat", imageName: "Zubat")
    createPokemon(name: "Meowth", imageName: "Meowth")
    createPokemon(name: "Psyduck", imageName: "Psyduck")
    createPokemon(name: "Rattatta", imageName: "Rattatta")
    createPokemon(name: "Abra", imageName: "Abra")
    createPokemon(name: "Weedle", imageName: "Weedle")
    createPokemon(name: "Pidgey", imageName: "Pidgey")
    createPokemon(name: "Charmander", imageName: "Charmander")
    createPokemon(name: "Bullbasaur", imageName: "Bullbasaur")
    createPokemon(name: "Jigglypuff", imageName: "Jigglypuff")
    createPokemon(name: "Caterpie", imageName: "Caterpie")
    createPokemon(name: "pokeStop", imageName: "pokestop")
}

func createPokemon(name: String, imageName: String) {
    if let context = (UIApplication.shared.delegate as?
        AppDelegate)?.persistentContainer.viewContext {
        let pokemon = Pokemon(context: context)
        pokemon.imageName = imageName
        pokemon.name = name
        try? context.save()
        
    }
}

func getPokemon() -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as?
        AppDelegate)?.persistentContainer.viewContext {
        if let pokemon =  try? context.fetch(Pokemon.fetchRequest())
            as? [Pokemon] {
            if let pokemons = pokemon {
                if pokemons.count == 0 {
                    addPokemon()
                    return getPokemon()
                } else {
                    return pokemons
                }
            }
        }
    }
    return []
}

func getCaughtPokemon(caught: Bool) -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as?
        AppDelegate)?.persistentContainer.viewContext {
        let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        if caught {
            fetchRequest.predicate = NSPredicate(format: "caught == true")
        } else {
            fetchRequest.predicate = NSPredicate(format: "caught == false")
        }
        if let pokemons =  try? context.fetch(fetchRequest) {
            return pokemons
        }
    }
    return []
}
