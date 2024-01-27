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
                    Alert(title: Text("Hello"), message: Text("Alert from React : \(self.message) "), dismissButton: .default(Text("OK"), action: {
                        self.showAlert = false
                        print("sending messge : \(self.message)")
                        self.viewModel.callbackValueFromNative.send("Hello from IOS")
                    }))
                }
                .onReceive(self.viewModel.webTitle, perform: { receivedTitle in
                    self.webTitle = receivedTitle
                })
                .onReceive(self.viewModel.showAlert, perform: {result in
                    self.showAlert = result
                })
                .onReceive(self.viewModel.callbackValueFromReactJS, perform: {result in
                //    self.showAlert = result
                    self.message = result
                    print(" message : \(self.message)")
                })
                
            }
        }
    }
}
