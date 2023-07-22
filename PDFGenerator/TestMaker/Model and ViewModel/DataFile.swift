//
//  DataFile.swift
//  PDFGenerator
//
//  Created by Raushan Kashyap on 21/07/23.
//

import Foundation

struct DataFile {
    private(set) var tests = Array<Test>()
//    init() {
//        tests = Array<Test>()
//        tests.append(Test(testName: "MTC1001", className: "10", subject: "Maths", fullMarks: "50", passMarks: "20", studentResult: [
//            StudentResultData(name: "Amit", section: "B", score: "42"),
//            StudentResultData(name: "Ranjit", section: "B", score: "48"),
//            StudentResultData(name: "Sujit", section: "A", score: "35"),
//            StudentResultData(name: "Manjit", section: "A", score: "24"),
//            StudentResultData(name: "Avnit", section: "B", score: "29"),
//        ]
//                         ))
//        tests.append(Test(testName: "MTC1002", className: "10", subject: "Maths", fullMarks: "50", passMarks: "20", studentResult: [
//            StudentResultData(name: "Amit", section: "B", score: "35"),
//            StudentResultData(name: "Ranjit", section: "B", score: "49"),
//            StudentResultData(name: "Sujit", section: "A", score: "15"),
//            StudentResultData(name: "Manjit", section: "A", score: "45"),
//            StudentResultData(name: "Avnit", section: "B", score: "32"),
//        ]
//                         ))
//    }
    
    func presentStudentAndHighStudentData(test: Test, presentStudent: StudentResultData) -> Array<StudentResultData> {
        let highStudent = highScoreStudentCalculator(test: test)
        var bothStudent = Array<StudentResultData>()
        bothStudent.append(highStudent)
        bothStudent.append(presentStudent)
        return bothStudent
    }
    
    func highScoreStudentCalculator(test: Test) -> StudentResultData {
        let testScoresData = test.studentResult
        //var highScoreStudent = [String: String]()
        var highScoreStudentData: StudentResultData?
        var highScore = 0.0
        for s in testScoresData {
            if highScore < Double(s.score)! {
                highScoreStudentData = s
                highScore = Double(s.score)!
            }
        }
        highScoreStudentData?.name = "HighScorer"
        return highScoreStudentData!
    }
    
    mutating func updateTests(tests: Array<Test>) {
        self.tests = tests
    }
    mutating func addTest(test: Test) {
        
        tests.append(test)
        //print(tests)
    }
    
    struct Test: Identifiable {
        let id = UUID()
        let testName: String
        let className: String
        let subject: String
        let fullMarks: String
        let passMarks: String
        
        let studentResult: Array<StudentResultData>
    }
    
    struct StudentResultData: Identifiable {
        let id = UUID()
        
        var name: String
        let section: String
        let score: String
    }
}
