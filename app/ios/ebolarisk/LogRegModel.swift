//
//  LogRegModel.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/14/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import Foundation

class LogRegModel {
    var intercept: Float
    var rangeScale: Float
    var terms: [String: ModelTerm]
    
    init(modelName name: String) {
        intercept = 0
        rangeScale = 0
        terms = [:]
        
        loadTerms(name: name)
        loadMinMax(name: name)
    }
    
    func matches(vars: Array<String>) -> Bool {
        let mvars = Array(terms.keys)
        return contains(first: mvars, second: vars) && contains(first: vars, second: mvars)
    }
    
    func contains(vars: Array<String>) -> Bool {
        let mvars = Array(terms.keys)
        return contains(first: vars, second: mvars)
    }
    
    func setIntercept(b0: Float) {
        intercept = b0;
    }
    
    func addTerm(term: ModelTerm) {
        terms[term.varName] = term
    }
    
    func eval(values: [String: Float]) -> Float {
        return sigmoid(z: evalScore(values: values))
    }

    func evalScore(values: [String: Float]) -> Float {
        var score = intercept
        for varName in values.keys {
            if let t = terms[varName], let x = values[varName] {
                score += t.eval(x: x);
            }
        }
        return score
    }
 
    func evalDetails(values: [String:Float]) -> [String:Array<Float>] {
        var details = [String:Array<Float>]()
        for varName in values.keys {
            if let t = terms[varName], let v = values[varName] {
                let coeff0 = t.coeff(i: 0)
                let contrib = t.eval(x: v)
                let scaledRange = abs(t.max - t.min) / rangeScale
                let scaledContrib = min(abs(contrib - t.min) / rangeScale, scaledRange)
                details[varName] = [v, contrib, scaledContrib, scaledRange, coeff0]                
            }
        }
        return details
    }
    
    func loadTerms(name: String) {
//        print("LOADING TERMS")
        let lines = loadStrings(forResource: "mice", ofType: "txt", inDirectory: "models/" + name)
        if let pos = indexOf(source: lines[0], substring: "est", offset: 2) {
            var rcsCoeffs = [Float]()
            let parenthesis = CharacterSet.init(charactersIn: "()")
            let apostrophe = CharacterSet.init(charactersIn: "'")
            
            var n = 1
            while (true) {
                let line = lines[n]
                n += 1
                if line.endIndex < pos {
                    continue
                }
                
                let s = trim(source: line[..<pos])
                let v = s.split(separator: " ")
                
                if v.count == 1 {
                    break
                }
                
                let valueStr = v[v.count - 1]
                if let value = Float(valueStr) {
                    if let pos0 = indexOf(source: s, substring: String(valueStr), offset: 0) {
                        let varStr = trim(source: s[..<pos0])
                        if startsWidth(source: varStr, substring: "rcs") {
                            if let pos1 = lastIndexOf(source: varStr, substring: ")", offset: 0) {
                                let rcsString = varStr[varStr.index(varStr.startIndex, offsetBy: 4)..<pos1]
                                let pieces = rcsString.split(separator: "c")

                                let part1 = pieces[0].split(separator: ",")
                                let varName = trim(source: part1[0])
                                if let rcsOrder = Int(trim(source: part1[1])) {
                                    let knotStr = pieces[1].trimmingCharacters(in: parenthesis).split(separator: ",")
                                    var rcsKnots = [Float]()
                                    for v in knotStr {
                                        rcsKnots.append(Float(trim(source: v))!)
                                    }
                                    
                                    let coeffOrder = varStr.count - varStr.trimmingCharacters(in: apostrophe).count
                                    
                                    if coeffOrder == 0 {
                                        rcsCoeffs = Array(repeating: 0.0, count: rcsOrder - 1)
                                    }
                                    
                                    if 0 < rcsCoeffs.count {
                                        rcsCoeffs[coeffOrder] = value
                                    }
                                    
                                    if coeffOrder == rcsOrder - 2 {
//                                        print("Adding RCS term of order " + String(rcsOrder) + " for " + varName + " with the following coefficients and knots:")
//                                        print(rcsCoeffs)
//                                        print(rcsKnots)
                                        let rcs = RCSTerm(variableName: varName, rcsOrder: rcsOrder, coefficients: rcsCoeffs, knots: rcsKnots)
                                        addTerm(term: rcs)
                                    }
                                }
                            }
                        } else {
                            if startsWidth(source: varStr, substring: "(Intercept)") {
//                                print("Setting the intercept to " + String(value))
                                setIntercept(b0: value);
                            } else {
//                                print("Adding linear term for " + varStr + " with the following coefficients: " + String(value))
                                let lin = LinearTerm(variableName: varStr, coefficient: value)
                                addTerm(term: lin);
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadMinMax(name: String) {
//        print("LOADING MINMAX")
        let lines = loadStrings(forResource: "minmax", ofType: "txt", inDirectory: "models/" + name)
        rangeScale = 0
        for line in lines {
            let pieces = line.split(separator: " ")
            if pieces.count < 3 {
                continue
            }
            let name = String(pieces[0])
            if let term = terms[name], let min = Float(pieces[1]), let max = Float(pieces[2]) {
//                print("Setting min and max for " + name + " " + String(min) + " " + String(max))
                term.setMin(m: min)
                term.setMax(m: max)
                let f = abs(max - min)
                if rangeScale < f {
                    rangeScale = f
//                    print("Updating range scale to " + String(rangeScale))
                }
            }
        }
    }
    
    func loadStrings(forResource name: String?, ofType ext: String?, inDirectory subpath: String?) -> Array<String> {
        //  https://stackoverflow.com/questions/27206176/where-to-place-a-txt-file-and-read-from-it-in-a-ios-project
        if let path = Bundle.main.path(forResource: name, ofType: ext, inDirectory: subpath) {
            let fm = FileManager()
            let exists = fm.fileExists(atPath: path)
            if exists {
                let content = fm.contents(atPath: path)
                if let contentAsString = String(data: content!, encoding: String.Encoding.utf8) {
                    let lines = contentAsString.components(separatedBy: "\n")
                    return lines
                }
            }
        }
        return [""]
    }
    
    // Utils
    
    func sigmoid(z: Float) -> Float {
        return 1.0 / (1.0 + exp(-z))
    }
    
    func contains(first: Array<String>, second: Array<String>) -> Bool {
        var all = true
        for element in second {
            if !first.contains(element) {
                all = false
                break
            }
        }
        return all
    }
    
    // String API cheatsheet
    // https://useyourloaf.com/blog/swift-string-cheat-sheet/
    func indexOf(source: String, substring: String, offset: Int) -> String.Index? {
        if let range = source.range(of: substring) {
            return source.index(range.lowerBound, offsetBy: offset, limitedBy: source.endIndex)
        } else {
            return nil
        }
    }
    
    func lastIndexOf(source: String, substring: String, offset: Int) -> String.Index? {
        if let range = source.range(of: substring, options: String.CompareOptions.backwards) {
            return source.index(range.lowerBound, offsetBy: offset, limitedBy: source.endIndex)
        } else {
            return nil
        }
    }
    
    func startsWidth(source: String, substring: String) -> Bool {
        if let range = source.range(of: substring) {
            return range.lowerBound == source.startIndex
        } else {
            return false
        }
    }
    
    func trim(source: String) -> String {
        return source.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func trim(source: Substring.SubSequence) -> String {
        return source.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func toString() -> String {
        var res = "Intercept: " + String(intercept)
        for term in terms.values {
            res += "\n" + term.toString();
        }
        return res;
    }
    
    class ModelTerm {
        var varName: String
        var min, max: Float
        
        init(variableName name: String) {
            varName = name
            min = 0
            max = 0
        }
        
        func coeff(i: Int) -> Float { return 0 }
        func eval(x: Float) -> Float { return 0 }
        func setMin(m: Float) { min = m }
        func setMax(m: Float) { max = m }
        func toString() -> String { return "" }
    }
    
    class LinearTerm: ModelTerm {
        var coeff: Float
        
        init(variableName name: String, coefficient c: Float) {
            coeff = c
            super.init(variableName: name)
        }
        
        override func coeff(i: Int) -> Float { return coeff }
        override func eval(x: Float) -> Float { return coeff * x }
        
        override func toString() -> String {
            var res = "Linear term for " + varName + "\n"
            res += "  Coefficient: " + String(coeff)
            res += "\n  Minimum value: " + String(min)
            res += "\n  Maximum value: " + String(max)
            return res
        }
    }
    
    class RCSTerm: ModelTerm {
        var order: Int
        var coeffs: Array<Float>
        var knots: Array<Float>

        init(variableName name: String, rcsOrder k: Int, coefficients c: Array<Float>, knots kn: Array<Float>) {
            order = k
            coeffs = c
            knots = kn
            super.init(variableName: name)
        }
        
        override func coeff(i: Int) -> Float {
            return coeffs[i]
        }
        
        override func eval(x: Float) -> Float {
            var sum = coeffs[0] * x
            for t in 1 ... order - 2 {
                sum += coeffs[t] * rcs(x: x, term: t);
            }
            return sum;
        }
        
        func cubic(u: Float) -> Float {
            let t = u > 0 ? u : 0
            return t * t * t
        }
        
        func rcs(x: Float, term: Int) -> Float {
            let k = order - 1
            let j = term - 1
            let t = knots
            let c = (t[k] - t[0]) * (t[k] - t[0])
            let value = +cubic(u: x - t[j]) - cubic(u: x - t[k - 1]) * (t[k] - t[j]) / (t[k] - t[k-1]) + cubic(u: x - t[k]) * (t[k - 1] - t[j]) / (t[k] - t[k-1])
            return value / c
        }
        
        override func toString() -> String {
            var res = "RCS term of order " + String(order) + " for " + varName + "\n"
            res += "  Coefficients:"
            for i in 0 ... coeffs.count - 1 {
                res += " " + String(coeffs[i])
            }
            res += "\n"
            res += "  Knots:"
            for i in 0 ... knots.count - 1 {
                res += " " + String(knots[i])
            }
            res += "\n  Minimum value: " + String(min)
            res += "\n  Maximum value: " + String(max)
            return res
        }
    }
}
