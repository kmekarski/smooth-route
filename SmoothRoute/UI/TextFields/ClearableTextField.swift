//
//  RegularTextFieldView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 29/10/2023.
//

import SwiftUI

struct ClearableTextField: View {

    var title: String
    @Binding var text: String
    var border: Bool = false
    var onClear: () -> () = {}
    var clearButtonVisible: Bool
    var invalid: Bool = false

    init(_ title: String, text: Binding<String>, clearButtonVisible: Bool, onClear: @escaping () -> () ) {
        self.title = title
        _text = text
        self.onClear = onClear
        self.clearButtonVisible = clearButtonVisible
    }
    
    init(_ title: String, text: Binding<String>, border: Bool, invalid: Bool, clearButtonVisible: Bool, onClear: @escaping () -> ()) {
        self.title = title
        _text = text
        self.border = border
        self.onClear = onClear
        self.clearButtonVisible = clearButtonVisible
        self.invalid = invalid
    }
    
    init(_ title: String, text: Binding<String>, clearButtonVisible: Bool) {
        self.title = title
        _text = text
        self.clearButtonVisible = clearButtonVisible
    }
    
    init(_ title: String, text: Binding<String>, border: Bool, clearButtonVisible: Bool) {
        self.title = title
        _text = text
        self.border = border
        self.clearButtonVisible = clearButtonVisible
    }
    

    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("", text: $text, prompt: Text(title).foregroundColor(.theme.secondaryText))
                .frame(height: 48)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .background(Color.theme.secondaryBackground)
                .foregroundColor(.theme.primaryText)
                .cornerRadius(10)
            if !text.isEmpty && clearButtonVisible {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.theme.secondaryText)
                .padding(.trailing, 16)
                .onTapGesture {
                    text = ""
                    onClear()
                }
            }
        }
        .shadow(color: border ? .theme.border : .black.opacity(0.15), radius: border ? 1 : 3, x: 0, y: border ? 0 : 2)
        .shadow(color: invalid ? .red : .clear, radius: border ? 1 : 3, x: 0, y: border ? 0 : 2)
        
    }
}

struct ClearableTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ClearableTextField("Current Location", text: .constant("123 Main St"), clearButtonVisible : true)
            ClearableTextField("Current Location", text: .constant(""), border: true, clearButtonVisible : true)
            ClearableTextField("Where you want to go?", text: .constant(""), clearButtonVisible: false)
        }
        .padding(32)
    }
}

