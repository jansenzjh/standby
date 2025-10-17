import SwiftUI
import GoogleSignInSwift

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var googlePhotosService: GooglePhotosService
    
    @State private var selectedCategory: String = UserDefaults.standard.string(forKey: "selectedGooglePhotosCategory") ?? "Nature"
    
    let categories = ["Pets", "Cities", "Nature"]
    
    var body: some View {
        NavigationView {
            Form {
                if googlePhotosService.isSignedIn {
                    Section(header: Text("Photo Categories")) {
                        Picker("Select Category", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { category in
                                Text(category)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: selectedCategory) { newCategory in
                            UserDefaults.standard.set(newCategory, forKey: "selectedGooglePhotosCategory")
                        }
                    }
                    
                    Section {
                        Button(action: {
                            googlePhotosService.signOut()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Sign Out of Google Photos")
                                .foregroundColor(.red)
                        }
                    }
                } else {
                    Section(header: Text("Account")) {
                        GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                            googlePhotosService.signIn()
                        }
                        .padding()
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
