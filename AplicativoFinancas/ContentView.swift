import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var context
    @State var isShowingSheet = false
    @Query(sort: \Gastos.data) var gastos: [Gastos]
    @State var gastoEditando: Gastos?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(gastos) {gasto in
                    GastoItem(gasto: gasto)
                        .onTapGesture {
                            gastoEditando = gasto
                        }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(gastos[index])
                    }
                }
            }
            .navigationTitle("Gastos")
            .sheet(isPresented: $isShowingSheet) { AddGastosSheet() }
            .sheet(item: $gastoEditando) { gasto in
                AtualizarGastosSheet(gasto: gasto)
            }
            .toolbar {
                if !gastos.isEmpty {
                    Button ("Adicionar Gasto", systemImage: "plus") {
                        isShowingSheet = true
                    }
                }
            }
            .overlay {
                if gastos.isEmpty {
                    ContentUnavailableView(label: {
                        Label("Sem gastos", systemImage: "list.bullet.rectangle.portrait")
                    }, description: {
                        Text("Adicione gastos para ver sua lista.")
                    }, actions: {
                        Button("Adicionar Gasto") { isShowingSheet = true}
                    })
                    .offset(y: -60)
                }
            }
            
            let gastoTotal = gastos.reduce(0) { $0 + $1.valor }
            Text("Gasto total: R$\(gastoTotal, specifier: "%.2f")")
                .bold()
                .font(.system(size: 20))
        }
    }
}

#Preview {
    ContentView()
}

struct GastoItem: View {
    
    let gasto:Gastos
    
    var body: some View {
        HStack {
            Text(gasto.data, format: Date.FormatStyle()
                .day(.twoDigits)
                .month(.twoDigits)
                .year(.twoDigits)
                .locale(Locale(identifier: "pt_BR")))
                .frame(width: 70, alignment: .leading)
            Spacer()
            Text(gasto.nome)
            Spacer()
            Text(gasto.valor, format: .currency(code: "BRL"))
                .foregroundStyle(.red)
        }
    }
}

struct AddGastosSheet: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State var nome: String = ""
    @State var data: Date = .now
    @State var valor: Double = 0
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Nome do gasto", text: $nome)
                DatePicker("Data", selection: $data, displayedComponents: .date)
                TextField("Valor", value: $valor, format: .currency(code: "BRL"))
            }
            .navigationTitle("Novo Gasto")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button("Cancelar") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        let gasto = Gastos(nome: nome, data: data, valor: valor)
                        context.insert(gasto)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AtualizarGastosSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @Bindable var gasto: Gastos
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Nome do gasto", text: $gasto.nome)
                DatePicker("Data", selection: $gasto.data, displayedComponents: .date)
                TextField("Valor", value: $gasto.valor, format: .currency(code: "BRL"))
            }
            .navigationTitle("Atualizar Gasto")
            .toolbar {
                ToolbarItem (placement: .confirmationAction) {
                    Button("Salvar") { dismiss()}
                }
            }
            
            
        }
    }
}
