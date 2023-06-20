//
//  File.swift
//  
//
//  Created by Thiago Henrique on 19/06/23.
//

import Foundation

struct Persona: Codable {
    let id: Int
    let name: String
    let characteristics: [String]
}

extension Persona {
    static var availablePersonas: [Persona] = [
        Persona(
            id: 1,
            name: "LoboHomem",
            characteristics: [
                "Com medo de água",
                "Gosta de ficar na régua e joga altinha na praia de copacabana",
                "Viciada em academia e toma whey"
            ]
        ),
        Persona(
            id: 2,
            name: "Vampiro",
            characteristics: [
                "Vegano",
                "Possui lente no dente",
                "Estilo gótico mas não fede"
            ]
        ),
        Persona(
            id: 3,
            name: "Frankstein ",
            characteristics: [
                "Workaholic",
                "Estilista que veste roupa que parecidas com o da lady gaga.",
                "Sensivel e introspectiva"
            ]
        ),
        Persona(
            id: 4,
            name: "Zumbi ",
            characteristics: [
                "Usuário de vape e da green",
                "Vaidoso, que vive checando seu penteado no espelho; cheiro de rato morto",
                "Vive na roça e odeia cidades e tecnologias, anda de carioca e fala que nem mineiro."
            ]
        ),
        Persona(
            id: 5,
            name: "Múmia ",
            characteristics: [
                "Rico futurista nostálgico",
                "Com medo de fogo",
                "Adora o carnaval brasileiro e gosta de sambar"
            ]
        )
    ].shuffled()
}
