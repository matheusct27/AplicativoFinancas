import Foundation
import SwiftData

@Model
class Gastos {
    var nome: String
    var data: Date
    var valor: Double
    
    init(nome: String, data: Date, valor: Double) {
        self.nome = nome
        self.data = data
        self.valor = valor
    }
}
