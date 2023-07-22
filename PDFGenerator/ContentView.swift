//
//  ContentView.swift
//  PDFGenerator
//
//  Created by Raushan Kashyap on 21/07/23.
//

import SwiftUI
import PDFKit

struct ContentView: View {
    var body: some View {
        VStack {
            CreateTestView()
        }
        .padding()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
