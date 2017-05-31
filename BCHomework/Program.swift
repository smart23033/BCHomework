//
//  Program.swift
//  Test01
//
//  Created by 김성준 on 2017. 5. 30..
//  Copyright © 2017년 김성준. All rights reserved.
//

import Foundation


let homeDirectory = NSHomeDirectory()
var studentArr = [Student]()
var passedStudentArr = [Student]()
var totalAvg = 0.0
var individualGrade = [String:String]()


func readJSONObject(){
    do {
        let path = homeDirectory + "/students.json"
//        print(path)
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        if let students = json as? [AnyObject] {
            //                    print(students)
            
            for student in students{
                guard let name = student["name"] as? String,
                    let grade = student["grade"] as? [String:Int] else { return }
                //                        print("\(name), \(grade)")
                
                let student = Student(name: name, grade: grade)
                
                studentArr.append(student)
            }
            
            studentArr.sort{$0.name < $1.name}
            
            //                    print(studentArr)
            
            
        } else {
            print("JSON is invalid")
        }
        
        
    } catch {
        print(error.localizedDescription)
    }
    
}

func getGrade(students:[Student]){
    
    for student in students {
        
        let dict = student.grade
        let avg = Double(Array(dict.values).reduce(0, +)) / Double(dict.count)
        
        totalAvg += avg
        
        switch avg {
        case 90..<100:
            individualGrade[student.name] = "A"
            passedStudentArr.append(student)
        case 80..<90:
            individualGrade[student.name] = "B"
            passedStudentArr.append(student)
        case 70..<80:
            individualGrade[student.name] = "C"
            passedStudentArr.append(student)
        case 60..<70:
            individualGrade[student.name] = "D"
        default:
            individualGrade[student.name] = "F"
        }
    }
    
    totalAvg = totalAvg / Double(students.count)
    
    //        print("totalAvg : \(totalAvg)")
}

func printResult(){
    
    var count = 0
    var result = ""
    let path = homeDirectory + "/result.txt"
    
    result += "전체 평균 : \(String(format: "%.2f", totalAvg))\n\n"
    result += "개인별 학점\n"
    for key in individualGrade.keys.sorted(by: <){
        result += "\(key) : \(individualGrade[key]!)\n"
    }
    result += "\n수료생\n"
    for student in passedStudentArr{
        result += "\(student.name)"
        
        if count != passedStudentArr.endIndex-1 {
            result += ", "
            count += 1
        }
    }
    
    do {
        try result.write(toFile: path, atomically: true, encoding: .utf8)
        print("출력 완료")
    } catch let error {
        print(error.localizedDescription)
    }
}
