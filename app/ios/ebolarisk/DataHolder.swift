//
//  DataHolder.swift
//  ebolarisk
//
//  Created by Andres Colubri on 4/15/18.
//  Copyright © 2018 broadinstitute. All rights reserved.
//

import Foundation

// Using singletons for global data access
// https://medium.com/if-let-swift-programming/the-swift-singleton-pattern-442124479b19
// https://stackoverflow.com/questions/38793601/singleton-usage-in-swift
final class DataHolder {
    var minModel: LogRegModel
    var fullModel: LogRegModel
    var wellModel: LogRegModel
    var floatVars: [String: Float]
    var floatExtra: [String: Float]
    
    static let instance = DataHolder()
    
    var hasModel = false
    var selModel: LogRegModel
    
    private init() {
        minModel = LogRegModel(modelName: "min")
        fullModel = LogRegModel(modelName: "kgh")
        wellModel = LogRegModel(modelName: "well")
        
        print("MINIMAL MODEL ========================")
        print(minModel.toString())
        print("FULL MODEL ========================")
        print(fullModel.toString())
        print("WELLNESS MODEL ========================")
        print(wellModel.toString())
        
        selModel = minModel
        
        floatVars = [:]
        floatExtra = [:]
    }
    
    func setData(varName: String, value: Bool) {
        print("-----> " + varName + ": " + String(value))
        if value {
            floatVars[varName] =  1.0
        } else {
            floatVars[varName] =  0.0
        }
        selectModel()
    }

    func setData(varName: String, value: Float) {
        print("-----> " + varName + ": " + String(value))
        if value.isNaN {
            floatVars.removeValue(forKey: varName)
        } else {
            floatVars[varName] = value
        }
        selectModel()
    }
    
    func remData(varName: String) {
        print("-----> Removed variable " + varName)
        floatVars.removeValue(forKey: varName)
        selectModel()
    }
    
    func setDataExtra(varName: String, value: Float) {
        print("-----> " + varName + ": " + String(value))
        if value.isNaN {
            floatExtra.removeValue(forKey: varName)
        } else {
            floatExtra[varName] = value
        }
    }
    
    func selectModel() {
        if fullModel.contains(vars: Array(floatVars.keys)) {
            print("===================== Selected Full Presentation Model")
            selModel = fullModel
            hasModel = true
        } else if wellModel.contains(vars: Array(floatVars.keys)) {
            print("===================== Selected Wellness Presentation Model")
            selModel = wellModel
            hasModel = true
        } else if minModel.contains(vars: Array(floatVars.keys)) {
            print("===================== Selected Minimal Presentation Model")
            selModel = minModel
            hasModel = true
        } else {
            print("===================== Not enough data to select a model")
            hasModel = false
        }
    }
    
    func getSelectedModel() -> LogRegModel? {
        if hasModel {
            return selModel
        } else {
            return nil
        }
    }
    
    func getCurrentData() -> [String: Float] {
        return floatVars
    }
    
    func getExtraData() -> [String: Float] {
        return floatExtra
    }
}
