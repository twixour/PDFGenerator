//
//  TextAndTextFieldView.swift
//  PDFGenerator
//
//  Created by Raushan Kashyap on 21/07/23.
//

import SwiftUI

struct TextAndTextFieldView: View {
    
    let headerName: String
    let textFieldPlaceholderName: String
    @Binding var textFieldName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(headerName)
                .font(.title3)
                .fontWeight(.semibold)
            TextField("\(textFieldPlaceholderName)", text: $textFieldName)
                .padding(10)
                .background(Color.white)
                .cornerRadius(20.0)
                .shadow(radius: 2, x:2, y: 2)
                .shadow(radius: 2, x:-2, y: -2)
                .disableAutocorrection(true)
        }
        .padding(2)
    }
}

struct TextAndTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextAndTextFieldView(headerName: "Test Name",textFieldPlaceholderName: "Test Name"  ,textFieldName: .constant("MTC1002"))
    }
}
