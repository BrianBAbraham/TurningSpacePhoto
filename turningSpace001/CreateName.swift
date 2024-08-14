//
//  CreateName.swift
//  CreateObject
//
//  Created by Brian Abraham on 09/01/2023.
//

import Foundation


struct ObjectId {
   static let objectId = PartTag.id0
}


struct ConnectStrings {
    static let symbol = PartTag.stringLink.rawValue


    static func byUnderscoreOrSymbol(
        _ first: String,
        _ second:String,
        _ symbol:String = PartTag.stringLink.rawValue)
    -> String {
        first + symbol + second //+ symbol
    }
}


//struct RemoveObjectName {
//    let nameToBeRemovedCharacterCount = CreateNameFromParts([Part.objectOrigin, PartTag.id0, PartTag.stringLink]).name.count
//    
//    func remove(_ name: String)
//        -> String {
//        let startIndex =
//           name.index(name.startIndex, offsetBy: nameToBeRemovedCharacterCount)
//        
//        return
//         String(name[startIndex...])
//    }
//}


struct CreateNameFromIdAndPart {
    var name: String
    
    init(_ id: PartTag, _ part: Parts) {
        
        name = getNameFromParts(id, part)
        
        func getNameFromParts(_ id: PartTag, _ part: Parts)
            -> String {
              //  let downcastPart = part as! Part
                let parts: [Parts] =
                [Part.objectOrigin, ObjectId.objectId, PartTag.stringLink, part , id, PartTag.stringLink, Part.mainSupport, PartTag.id0]
                   return
                    CreateNameFromParts(parts ).name
        }
    }
}

struct CreateNameFromParts {
    var name: String = ""
    
    init(_ parts: [Parts]) {
        name = getNameFromParts(parts)
    }
    
    private func getNameFromParts(_ parts: [Parts]) -> String {
        var name = ""
        for item in parts {
            name += item.stringValue
        }
        return name
    }
}


struct GetUniqueNamesX {
    let forPart: [String]
  
    init(_ dictionary: PositionDictionary) {
        forPart = getUniquePartNamesOfCornerItems(dictionary)
       
        func getUniquePartNamesOfCornerItems(_ dictionary: [String: PositionAsIosAxes] ) -> [String] {
            var uniqueNames: [String] = []
            let cornerKeys = dictionary.filter({$0.key.contains(PartTag.corner.rawValue)}).keys
           // print(cornerKeys)
            var removedName = ""
            var nameWithoutCornerString = ""
            let cornerName = PartTag.stringLink.rawValue + PartTag.corner.rawValue
            for cornerKey in cornerKeys {
                for index in 0...3 {
                    removedName = cornerName + String(index)
                    nameWithoutCornerString = String(cornerKey.replacingOccurrences(of: removedName, with: ""))
                    
                    if nameWithoutCornerString != cornerKey {
                        uniqueNames.append(nameWithoutCornerString)
                    }
                }
            }
            return uniqueNames.removingDuplicates()
        }
    }
}



//struct UniqueNamesForDimensions {
//
//    var are: [String] = []
//    
//
//    init(_ dictionary: Part3DimensionDictionary) {
//
//        are = getUniqueNameForDimensions(dictionary)
//
//
//
//        func getUniqueNameForDimensions(_ dictionary: Part3DimensionDictionary ) -> [String] {
//            var uniqueNames: [String] = []
//            for (key, _) in dictionary {
//                let components =
//                key.split(separator: "_")
//                if let firstPart = components.first {
//                    uniqueNames.append(String(firstPart) )
//                }
//            }
//            return uniqueNames
//        }
//    }
//}

//struct GetGeneralName {
//    let fromUniquePartName: String
//
//    init(_ uniqueName: String) {
//        fromUniquePartName = getName(uniqueName)
//
//        func getName(_ uniqueName: String)
//            -> String {
//           let firstItemIsTheCommonName: Int = 0
//           let nameInSplitForm: [String] =
//            uniqueName.components(separatedBy: ConnectStrings.symbol)
//            return nameInSplitForm[firstItemIsTheCommonName]
//        }
//    }
//}



struct ParentToPartName {
    func convertedToObjectToPart(_ parentToPartName: String)
        -> String {
        var editedString = parentToPartName
        var underscoreCount = 0
        var startIndex: String.Index?
            let objectName = Part.objectOrigin.rawValue + ObjectId.objectId.rawValue + PartTag.stringLink.rawValue

        for (index, character) in editedString.enumerated() {
            if character == "_" {
                underscoreCount += 1
                if underscoreCount == 2 {
                    startIndex = editedString.index(editedString.startIndex, offsetBy: index + 1)
                    break
                }
            }
        }

        if let startIndex = startIndex {
            editedString = objectName + String(editedString[startIndex...])
        }
//print(parentToPartName)
//print(editedString)
//print("\n\n")
            return editedString
    }
    
}


struct UniqueToGeneralNameX {
    let uniqueName: String
    let generalName: String
    
    init(_ uniqueName: String) {
        self.uniqueName = uniqueName
        generalName = getGeneralName()
        
        func getGeneralName() -> String {
            let components = uniqueName.split(separator: "_")
            
            if components.count > 2 {
                let desiredSubstring = String(components[2])
                return desiredSubstring
            } else {
               return ""
            }
        }
    }
}


struct UniqueToGeneralName {
    let uniqueName: String
    let generalName: String
    
    init(_ uniqueName: String) {
        self.uniqueName = uniqueName
        self.generalName = UniqueToGeneralName.getGeneralName(from: uniqueName)
    }
    
    private static func getGeneralName(from uniqueName: String) -> String {
        let components = uniqueName.split(separator: "_")
        if components.count > 2 {
            let desiredSubstring = String(components[2])
            return desiredSubstring
        } else {
            return ""
        }
    }
}



struct BilateralSideIsRight {
    
    // Public method to check the string
    static func checkCharacter(in input: String) -> PartTag {
        return checkCharacterPrivately(input)
    }
    
    // Private method that actually does the checking
    private static func checkCharacterPrivately(_ input: String) -> PartTag {
        let parts = input.split(separator: "_")
        
        if parts.count > 3 {
            let targetPart = parts[3] // This is the part after the third underscore
            
            if targetPart.count >= 3 {
                let index = targetPart.index(targetPart.startIndex, offsetBy: 2)
                let character = targetPart[index]
                
                if character == "1" {
                    return .id1
                } else if character == "0" {
                    return .id0
                }
            }
        }
        
        fatalError()
        // If the string doesn't match the expected format
    }
}


//immediately after second underscore prepends to generic name
struct PrependArcNameToGenericNamePart {
    
    static func get(_ originalStrings: [String]) -> [String] {
        let name = PartTag.arcPoint.rawValue
        // Map each original string to a new string with the insertion
        return originalStrings.map { originalString -> String in
            // Split the original string by underscore
            var components = originalString.split(separator: "_").map(String.init)
            
            // Check if there are at least three elements
            guard components.count >= 3 else {
                print("One of the strings does not contain enough components: \(originalString)")
                return originalString
            }
            
            // Insert the string to insert before the third component
            components[2] = name + components[2]
            
            // Join the components back together with underscores
            return components.joined(separator: "_")
        }
    }
}


struct SubstringBefore {
   static func get(substring: String, in names: [String]) -> [String] {
        var prefixNames: [String] = []
        for name in names {
            guard let range = name.range(of: substring) else {
                fatalError()
            }
            
            let startIndex = name.startIndex
            let endIndex = range.lowerBound
            
            prefixNames.append(
                String(name[startIndex..<endIndex]))
        }
       
       if prefixNames.count < 2  {
           fatalError()
       }
        return Array(Set(prefixNames))
    }
}



struct RemovePrefix {
    
    static func get(_ prefix: String, _ names: [String]) -> [String] {
        let anyNameWillDo = names[0]
        let characterCount = countCharactersBefore(subString: prefix, in: anyNameWillDo)
        let modifiedNames = names.map { $0.dropFirst(characterCount) }
        return
            modifiedNames.map { String($0) }
    }
    
    static func countCharactersBefore(subString: String, in string: String) -> Int {
        if let range = string.range(of: subString) {
            let prefix = string[string.startIndex..<range.lowerBound]
            return prefix.count
        }
        fatalError()
    }

}



struct SortStringsByEmbeddedNumber {
    func get(_ strings: [String]) -> [String] {
        // Function to extract integer from string
        func extractNumber(from string: String) -> Int? {
            let pattern = "[0-9]+"
            if let range = string.range(of: pattern, options: .regularExpression) {
                let numberStr = String(string[range])
                return Int(numberStr)
            }
            return nil
        }
        
        // Sorting the array using the extracted numbers
        return strings.sorted {
            guard let num1 = extractNumber(from: $0), let num2 = extractNumber(from: $1) else {
                return false
            }
            return num1 < num2
        }
    }
}


struct ReplaceCharBeforeSecondUnderscore {
    
  static  func get(in string: String, with replacement: String) -> String {
        let underscoreIndexes = string.enumerated().filter { $0.element == "_" }.map { $0.offset }
        
        guard underscoreIndexes.count >= 2 else {
            print("Error: Expected at least two underscores in the string.")
            return string
        }
        
        let secondUnderscoreIndex = underscoreIndexes[1]
        let indexBeforeSecondUnderscore = string.index(string.startIndex, offsetBy: secondUnderscoreIndex - 1)
        
        if secondUnderscoreIndex > 0, string.distance(from: string.startIndex, to: indexBeforeSecondUnderscore) >= 0 {
            let startIndex = string.startIndex
            let endIndex = string.index(before: indexBeforeSecondUnderscore)
            let stringStart = string[startIndex...endIndex]
            
            let replacementStartIndex = string.index(after: endIndex)
            let replacementEndIndex = string.index(after: indexBeforeSecondUnderscore)
            let stringEnd = string[replacementEndIndex...]
            
            return stringStart + replacement + stringEnd
        } else {
            print("Error: Cannot replace character before the second underscore.")
            return string
        }
    }
}

struct StringAfterSecondUnderscore {

    static func get(in strings: [String]) -> [String] {
        return strings.map { string in
            let underscoreIndexes = string.enumerated().filter { $0.element == "_" }.map { $0.offset }
            
            guard underscoreIndexes.count >= 2 else {
                print("Error: Expected at least two underscores in '\(string)'.")
                return string
            }
            
            let secondUnderscoreIndex = underscoreIndexes[1]
            let indexAfterSecondUnderscore = string.index(string.startIndex, offsetBy: secondUnderscoreIndex + 1)
            
            if secondUnderscoreIndex > 0 {
                return String(string[indexAfterSecondUnderscore...])  // Substring from the character after the second underscore to the end of the string
            } else {
                print("Error: Cannot remove characters before the second underscore in '\(string)'.")
                return string
            }
        }
    }
}

//}

//extension String {
//    var capitalizeFirstLetter: String {
//        // 1
//        let firstLetter = self.prefix(1).capitalized
//        // 2
//        let remainingLetters = self.dropFirst()
//        // 3
//        return firstLetter + remainingLetters
//    }
//}


