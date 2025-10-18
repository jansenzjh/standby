import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var localPhotosService: LocalPhotosService
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Photos")) {
                    if !localPhotosService.isAuthorized {
                        Button(action: {
                            localPhotosService.requestAuthorization()
                        }) {
                            Text("Authorize Photo Library Access")
                        }
                    } else {
                        Text("Photo library access authorized.")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
