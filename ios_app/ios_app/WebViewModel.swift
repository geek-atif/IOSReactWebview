//
//  WebViewModel.swift
//  Created by Atif Qamar on 26/01/24.
//


import Foundation
import Combine

class WebViewModel : ObservableObject {
    
    // Title of the HTML page
    var webTitle = PassthroughSubject<String, Never>()
    
    // Javascript to iOS
    var showAlert = PassthroughSubject<Bool, Never>()
    
    // iOS to Javascript
    var callbackValueFromNative = PassthroughSubject<String, Never>()
    
    // Javascript to IOS
    var callbackValueFromReactJS = PassthroughSubject<String, Never>()
}
