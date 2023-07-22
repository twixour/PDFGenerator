//
//  PDFChangeView.swift
//  PDFGenerator
//
//  Created by Raushan Kashyap on 21/07/23.
//

import SwiftUI
import Charts

struct NewItem: Identifiable {
    var id = UUID()
    let name: String
    let section: String
    let score: Double
}

struct PDFChangeView: View {
    @ObservedObject var viewModel = DataViewModel()
    let fullMarks: String
    let passMarks:String
    let subject:String
    let testName:String
    let className:String
    let name:String
    let section:String
    let score:String
    let test: DataFile.Test
    
  
    
    var body: some View {
        VStack{
            Text("Test Name:- \(testName)")
                .font(.title)
                .fontWeight(.heavy)
            HStack {
                Text("F.M.:- \(fullMarks)")
                Text("P.M.:- \(passMarks)")
            }
            .font(.title3)
            .fontWeight(.bold)
            HStack {
                Text("Subject:- \(subject)")
                Text("Class:- \(className)")
            }
            .font(.title3)
            .fontWeight(.bold)
            
            HStack(spacing: 80) {
                VStack{
                    Text("Name")
                    Text(name)
                        //.frame(width:80, height: 50)

                }
                VStack {
                    Text("Section")
                    Text(section)
                }
                VStack {
                    Text("Score")
                    Text(score)
                }
                
            }
            .padding()
            .font(.title3)
            .fontWeight(.bold)
            
            Chart(viewModel.presentStudentAndHighStudentData(test: test, presentStudent: DataFile.StudentResultData(name: name, section: section, score: score))) { student in
                BarMark(
                    x: .value("Name", student.name),
                    y: .value("Score", Double(student.score)!)
                )
            }
            .frame(width: 100, height: 300)
            //            Chart(newItems) {newItem in
            //                BarMark(
            //                    x: .value("Department",newItem.type),
            //                    y: .value("Profit",newItem.score)
            //                )
            //                .foregroundStyle(Color.gray.gradient)
            //            }
            //            .frame(width: 200,height: 400)
        } // VStack ends here
        
    } // body ends here
    
    func highScore(test: DataFile.Test) -> DataFile.StudentResultData {
        let testScoresData = test.studentResult
        //var highScoreStudent = [String: String]()
        var highScoreStudentData: DataFile.StudentResultData?
        var highScore = 0.0
        for s in testScoresData {
            if highScore < Double(s.score)! {
                highScoreStudentData = s
                highScore = Double(s.score)!
            }
        }
        return highScoreStudentData!
        
    }
}

struct PDFChangeView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        PDFChangeView(fullMarks: "50", passMarks: "25", subject: "MATHS", testName: "MTC1003", className: "10", name: "Amit", section: "B", score: "45", test: DataFile.Test(testName: "MTC1001", className: "10", subject: "MATHS", fullMarks: "50", passMarks: "25", studentResult: [
            DataFile.StudentResultData(name: "Amit", section: "B", score: "42"),
            DataFile.StudentResultData(name: "Ranjit", section: "B", score: "40"),
            DataFile.StudentResultData(name: "Sujit", section: "A", score: "35"),
            DataFile.StudentResultData(name: "Manjit", section: "A", score: "24"),
            DataFile.StudentResultData(name: "Avnit", section: "B", score: "29"),
        ]))
    }
}
