import SwiftUI
import SwiftData

@main
struct AplicativoFinancasApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Gastos.self)
    }
}
