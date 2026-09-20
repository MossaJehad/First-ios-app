import SwiftUI
import SwiftData

@main
struct TodoEditorialApp: App {
    let modelContainer: ModelContainer
    
    init() {
        FontRegistrar.registerFonts()
        
        do {
            let schema = Schema([TodoTask.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            modelContainer = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainContainerView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(modelContainer)
    }
}
