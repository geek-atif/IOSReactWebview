//
//  WebViewScreen.swift
//  Created by Atif Qamar on 26/01/24.
//



import SwiftUI

struct WebViewScreen: View {
    
    @ObservedObject var viewModel = WebViewModel()
    @State var bar = false
    @State var webTitle : String = ""
    @State var showAlert : Bool = false
    @State var message : String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    MyWebView(url: URL(string: "http://localhost:3000/home"), viewModel: viewModel)
                }
                .navigationBarTitle(Text(webTitle), displayMode: .inline)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Received Message From React :"), message: Text(self.message), dismissButton: .default(Text("OK"), action: {
                        self.showAlert = false
                        let randomInt = Int.random(in: 0..<3000)
                        let sendMessage  = "\(self.message)_\(randomInt)"
                        print(sendMessage)
                        self.viewModel.callbackValueFromNative.send(sendMessage)
                    }))
                }
                .onReceive(self.viewModel.webTitle, perform: { receivedTitle in
                    self.webTitle = receivedTitle
                })
                .onReceive(self.viewModel.showAlert, perform: {result in
                    self.showAlert = result
                })
                .onReceive(self.viewModel.callbackValueFromReactJS, perform: {result in
                    self.message = result
                    print(" message : \(self.message)")
                })
                
            }
        }
    }
}
