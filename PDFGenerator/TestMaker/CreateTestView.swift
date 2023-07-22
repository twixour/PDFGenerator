//
//  CreateTestView.swift
//  PDFGenerator
//
//  Created by Raushan Kashyap on 21/07/23.
//

import SwiftUI
import UIKit

@MainActor
struct CreateTestView: View {
    @ObservedObject var modelView = DataViewModel()
    @State private var testName:String = ""
    @State private var fullMarks:String = ""
    @State private var passMarks:String = ""
    @State private var className:String = ""
    @State private var subject: String = ""
    
    @State private var disableGeneratePDF = true
    
    @State private var fileName = ""
    @State private var openFile = false
    
    @State private var pdfGenerationNotification = ""
    @State private var isLoading = false
    @State private var progressValue = 0.0
    
    var body: some View {
        VStack {
            VStack {
                Text("Test Result")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                TextAndTextFieldView(headerName: "Test Name", textFieldPlaceholderName: "Test Name", textFieldName: $testName)
                HStack {
                    TextAndTextFieldView(headerName: "Full Marks", textFieldPlaceholderName: "Full Marks", textFieldName: $fullMarks)
                    TextAndTextFieldView(headerName: "Pass Marks", textFieldPlaceholderName: "Pass Marks", textFieldName: $passMarks)
                }
                
                HStack {
                    TextAndTextFieldView(headerName: "Class", textFieldPlaceholderName: "Class", textFieldName: $className)
                    
                    TextAndTextFieldView(headerName: "Subject", textFieldPlaceholderName: "Subject", textFieldName: $subject)
                }
                
               
                
            }
            .padding(.bottom ,10)
            
            HStack {
                
                Button(action:{
                    openFile.toggle()
                    disableGeneratePDF.toggle()
                }) {
                    Text("Load CSV File")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(width:180, height: 50)
                        .background(Color.green)
                        .cornerRadius(15.0)
                        .shadow( radius: 2, x:2, y: 2)
                        .shadow(radius: 2, x:-2, y: -2)
                }
                Spacer()
                Button(action:{
                    if((modelView.testResultData) != nil) {
                        if(!testName.isEmpty) {
                            
                            modelView.makeTest(test: DataFile.Test(testName: testName, className: className, subject: subject, fullMarks: fullMarks, passMarks: passMarks, studentResult: modelView.testResultData!))
                            
                        }
                    }
                }) {
                    Text("Create Test")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(width:180, height: 50)
                        .background(Color.green)
                        .cornerRadius(15.0)
                        .shadow( radius: 2, x:2, y: 2)
                        .shadow(radius: 2, x:-2, y: -2)
                }
                
                
            } // HStack ends here
            
            Button(action:{
                if((modelView.test) != nil) {
                    pdfGenerationNotification = "Generating PDF"
                    self.isLoading = true
                    createPDF(test: modelView.test!)
                    
                }
            }) {
                Text("Genereate PDF")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(width:180, height: 50)
                    .background(Color.green)
                    .cornerRadius(15.0)
                    .shadow( radius: 2, x:2, y: 2)
                    .shadow(radius: 2, x:-2, y: -2)
            }
            .padding([.leading, .trailing],80)
            
            
            HStack {
                Text(pdfGenerationNotification)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            if isLoading {
                
                HStack {
                    ProgressView(value: progressValue, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle())
                        .frame(width: 200)
                    Text("\(Int(progressValue * 100)) %")
                }
                
                
                
            }
            
            
            if(pdfGenerationNotification == "PDF Generated") {
                ShareLink("Export All PDF", items: downloadAllPDF(test: modelView.test!))
                
                
                Button(action:{
                    deleteAllPDFs(test: modelView.test!)
                }) {
                    Text("Delete Generated PDF")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 50)
                        .background(.red)
                        .cornerRadius(15.0)
                        .shadow(radius: 2, x: 2, y: 2)
                        .shadow(radius: 2, x: -2, y: -2)
                }
                
            }
            
            Spacer()
        } .padding()// main VStack ends
            .fileImporter(isPresented: $openFile, allowedContentTypes: [.commaSeparatedText]) { result in
                do {
                    let fileURL = try result.get()
                    modelView.changeFilepath(filePath: fileURL)
                    modelView.testResultData = modelView.loadCSVData(filePathURL: modelView.filePath!)
                    
                    self.fileName =  fileURL.lastPathComponent
                    
                }  // do ends here
                catch {
                    print("error reading docs")
                    print(error.localizedDescription)
                } // catch ends here
                
            } // file Importer ends here
    } // body ends here
    
    // createPDF starts
    
    func createPDF(test: DataFile.Test)  {
        
        var tempViews = Array<PDFChangeView>()
        for s in test.studentResult {
            tempViews.append(PDFChangeView(fullMarks: test.fullMarks, passMarks: test.passMarks, subject: test.subject, testName: test.testName, className: test.className, name: s.name, section: s.section, score: s.score, test: test))
        }
        
        for (index, view) in tempViews.enumerated() {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)) {
                let image = view.asImage()
                let pdfData = image.asPDF()
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let filePath = documentsDirectory.appendingPathComponent("\(test.testName)")
                
                if !FileManager.default.fileExists(atPath: filePath.path) {
                    do {
                        try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                    } catch {
                        print("Couldn't create document directory")
                    }
                }
                
                let fileURL =  filePath.appendingPathComponent("\(view.name) \(view.section).pdf")
                print("printing....")
                
                print("file url: - \(fileURL)")
                print("printing done....")
                
                do {
                    try pdfData.write(to: fileURL)
                    progressValue = Double(Double(index) / Double(tempViews.count))
                    print("update value = \(progressValue)")
                    if(index + 1 == tempViews.count) {
                        pdfGenerationNotification = "PDF Generated"
                        self.isLoading = false
                        
                    }
                } catch {
                    print("Error saving PDF: \(error)")
                }
                
            } // dispatch queue ends
        } // for loop of tempviews ends
        
        // pdfGenerationNotification = "PDF Generated"
        
    } // createPDF function ends here
    
    func downloadAllPDF(test: DataFile.Test) -> [URL]{
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsDirectory.appendingPathComponent("\(test.testName)")
        
        do {
            // Get the contents of the directory
            let files = try FileManager.default.contentsOfDirectory(at: filePath, includingPropertiesForKeys: nil)
            
            // Return the files
            
            return files
        } catch {
            // If there was an error getting the files, print the error and return an empty array
            print("Error getting files: \(error)")
            return []
        }
    }
    
    // delete all PDFs begins
    func deleteAllPDFs(test: DataFile.Test){
        let fileManager = FileManager.default
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsDirectory.appendingPathComponent("\(test.testName)")
        
        do {
            let filePaths = try FileManager.default.contentsOfDirectory(at: filePath, includingPropertiesForKeys: nil)
            for filePath in filePaths {
                try fileManager.removeItem(at: filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    // delete all PDFs ends
}  // struct ends here






extension View {
    func asImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}



extension UIImage {
    func asPDF() -> Data {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: self.size))
        
        return pdfRenderer.pdfData { ctx in
            ctx.beginPage()
            self.draw(in: CGRect(origin: .zero, size: self.size))
        }
    }
}









struct CreateTestView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTestView()
    }
}


