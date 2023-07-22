//
//  DataViewModel.swift
//  PDFGenerator
//
//  Created by Raushan Kashyap on 21/07/23.
//

import SwiftUI

class DataViewModel: ObservableObject {
    @Published var model = DataFile()
    
    var testResultData: Array<DataFile.StudentResultData>?
    var test: DataFile.Test?
    
    var filePath: URL?
    
    func changeFilepath(filePath: URL) {
        self.filePath = filePath
        
    }
    
    // functions
    
    
    func createTest(testName: String,className: String, fullMarks: String, passMarks: String, subject: String, testResultData: Array<DataFile.StudentResultData>) -> DataFile.Test {
        let test = DataFile.Test(testName: testName, className: className, subject: subject, fullMarks: fullMarks, passMarks: passMarks, studentResult: testResultData)
         return test
     }
     // This creates the test
    func makeTest(test: DataFile.Test) {
        self.test = test
    }
     func addTest(test: DataFile.Test) {
         model.addTest(test: test)
     }
    
    func presentStudentAndHighStudentData(test: DataFile.Test, presentStudent: DataFile.StudentResultData) -> Array<DataFile.StudentResultData> {
        return model.presentStudentAndHighStudentData(test: test, presentStudent: presentStudent)
    }
    
    func highScoreStudentCalculator(test: DataFile.Test) -> DataFile.StudentResultData {
        return model.highScoreStudentCalculator(test: test)
    }
    
    
    func cleanRows(file: String) -> String {
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    // load CSV file
    
    func loadCSVData(filePathURL: URL) -> [DataFile.StudentResultData] {
        var csvToStruct = [DataFile.StudentResultData]()

        var data = ""
        //var data1 = ""
        do {
                data = try String(contentsOf: filePathURL)
            }
        catch {
            print(error)
            return []
        }
        
        data = cleanRows(file: data)
        var eachResultRecord = data.components(separatedBy: "\n")
        eachResultRecord.removeFirst()
        
        for row in eachResultRecord {
            
            let perScoreDetail = row.components(separatedBy: ",")
            
            if perScoreDetail.count == eachResultRecord.first?.components(separatedBy: ",").count {
                let linesStruct = DataFile.StudentResultData(name: perScoreDetail[0], section: perScoreDetail[1], score: perScoreDetail[2])
                //let linesStruct = DataFile.StudentResultData.init(raw: perScoreDetail)
                csvToStruct.append(linesStruct)
            }
        }
        
        return csvToStruct
    }
    
    
    
    var tests: Array<DataFile.Test> {
        return model.tests
    }
}
