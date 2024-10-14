//
//  PatternView.swift
//  NeueBluetooth
//
//

import SwiftUI
import CoreGraphics
import PhotosUI

// Hilfsfunktion, um die durchschnittliche Farbe für einen bestimmten Bereich des Bildrands zu berechnen
func averageColorForSegment(image: UIImage, segmentIndex: Int, totalSegmentsTopBottom: Int, totalSegmentsLeftRight: Int, width: Int, height: Int) -> Color {
    let bytesPerPixel = 4
    let bytesPerRow = bytesPerPixel * width
    let totalPixels = width * height
    var totalRed: Int = 0
    var totalGreen: Int = 0
    var totalBlue: Int = 0
    var pixelCount: Int = 0
    
    // Create a context to draw the image in and extract pixel data
    guard let cgImage = image.cgImage,
          let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
          let pixelData = context.data else {
        return .gray
    }
    
    context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
    let data = pixelData.bindMemory(to: UInt8.self, capacity: totalPixels * bytesPerPixel)
    // Berechne die Anzahl der Pixel pro Segment entlang der jeweiligen Ränder
    let segmentLengthTopBottom = width / totalSegmentsTopBottom
    let segmentLengthLeftRight = height / totalSegmentsLeftRight
    
    // Bestimme die Pixel für das entsprechende Segment
    if segmentIndex < totalSegmentsTopBottom { // Oberer Rand
        let startX = segmentIndex * segmentLengthTopBottom
        for x in startX..<(startX + segmentLengthTopBottom) {
            let pixelIndex = x * bytesPerPixel
            totalRed += Int(data[pixelIndex])
            totalGreen += Int(data[pixelIndex + 1])
            totalBlue += Int(data[pixelIndex + 2])
            pixelCount += 1
        }
    } else if segmentIndex < totalSegmentsTopBottom * 2 { // Unterer Rand
        let startX = (segmentIndex - totalSegmentsTopBottom) * segmentLengthTopBottom
        for x in startX..<(startX + segmentLengthTopBottom) {
            let pixelIndex = ((height - 1) * width + x) * bytesPerPixel
            totalRed += Int(data[pixelIndex])
            totalGreen += Int(data[pixelIndex + 1])
            totalBlue += Int(data[pixelIndex + 2])
            pixelCount += 1
        }
    } else if segmentIndex < totalSegmentsTopBottom * 2 + totalSegmentsLeftRight { // Linker Rand
        let startY = (segmentIndex - totalSegmentsTopBottom * 2) * segmentLengthLeftRight
        for y in startY..<(startY + segmentLengthLeftRight) {
            let pixelIndex = y * width * bytesPerPixel
            totalRed += Int(data[pixelIndex])
            totalGreen += Int(data[pixelIndex + 1])
            totalBlue += Int(data[pixelIndex + 2])
            pixelCount += 1
        }
    } else { // Rechter Rand
        let startY = (segmentIndex - totalSegmentsTopBottom * 2 - totalSegmentsLeftRight) * segmentLengthLeftRight
        for y in startY..<(startY + segmentLengthLeftRight) {
            let pixelIndex = (y * width + (width - 1)) * bytesPerPixel
            totalRed += Int(data[pixelIndex])
            totalGreen += Int(data[pixelIndex + 1])
            totalBlue += Int(data[pixelIndex + 2])
            pixelCount += 1
        }
    }
    
    // Berechne die durchschnittliche Farbe
    return Color(
        red: Double(totalRed) / Double(pixelCount) / 255.0,
        green: Double(totalGreen) / Double(pixelCount) / 255.0,
        blue: Double(totalBlue) / Double(pixelCount) / 255.0
    )
}

struct FavoritePattern: Identifiable {
    var id = UUID()
    var name: String
    var categoryName: String
    var version: Int
    var speed: Double
    var isBouncing: Bool
}

struct PatternView: View {
    // Alle Muster Arrays
    @EnvironmentObject var patternManager: PatternManager
    @EnvironmentObject var bluetoothManager: BluetoothManager
    @EnvironmentObject var languageManager: LanguageManager
    @AppStorage("selectedBackground") var selectedBackground = "background1"
    
    // Die Vorschaukreise
    @State private var circleColors: [Color] = Array(repeating: .gray, count: 20)
    // Ausgewählte Kategorie und Muster
    @State private var selectedCategory: String?
    @State private var selectedPattern: String?
    // Geschwindigkeit und Zeit
    @State private var speed: Double = 0.5
    @State private var currentTime: Double = 0.0
    // Zustandsvariablen für links-rechts bounce
    @State private var isBouncing: Bool = false
    //Für Favoriten Button
    @State private var favorites: [String: Bool] = [:]
    @State private var favoritePatterns: [FavoritePattern] = []
    // Für Interrupts
    @State private var currentTask: DispatchWorkItem?
    @State private var currentTask2: DispatchWorkItem?
    // Wallpaper Variablen
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    
    func showPatternHelper(ledPattern: [(ledIndex1: UInt8, led1R: UInt8, led1G: UInt8, led1B: UInt8, ledIndex2: UInt8, led2R: UInt8, led2G: UInt8, led2B: UInt8, ledIndex3: UInt8, led3R: UInt8, led3G: UInt8, led3B: UInt8, ledIndex4: UInt8, led4R: UInt8, led4G: UInt8, led4B: UInt8, ledIndex5: UInt8, led5R: UInt8, led5G: UInt8, led5B: UInt8, ledIndex6: UInt8, led6R: UInt8, led6G: UInt8, led6B: UInt8, ledIndex7: UInt8, led7R: UInt8, led7G: UInt8, led7B: UInt8, ledIndex8: UInt8, led8R: UInt8, led8G: UInt8, led8B: UInt8, ledIndex9: UInt8, led9R: UInt8, led9G: UInt8, led9B: UInt8, ledIndex10: UInt8, led10R: UInt8, led10G: UInt8, led10B: UInt8, ledIndex11: UInt8, led11R: UInt8, led11G: UInt8, led11B: UInt8, ledIndex12: UInt8, led12R: UInt8, led12G: UInt8, led12B: UInt8, ledIndex13: UInt8, led13R: UInt8, led13G: UInt8, led13B: UInt8, ledIndex14: UInt8, led14R: UInt8, led14G: UInt8, led14B: UInt8, ledIndex15: UInt8, led15R: UInt8, led15G: UInt8, led15B: UInt8, ledIndex16: UInt8, led16R: UInt8, led16G: UInt8, led16B: UInt8, ledIndex17: UInt8, led17R: UInt8, led17G: UInt8, led17B: UInt8, ledIndex18: UInt8, led18R: UInt8, led18G: UInt8, led18B: UInt8, ledIndex19: UInt8, led19R: UInt8, led19G: UInt8, led19B: UInt8, ledIndex20: UInt8, led20R: UInt8, led20G: UInt8, led20B: UInt8, duration: TimeInterval)], speed: Double, isBouncing: Bool) {
        currentTask?.cancel() // Cancel any previous task
        currentTime = 0.0
        
        var task: DispatchWorkItem!
        let isRunning = true // Flag to control animation loop
        
        task = DispatchWorkItem {
            currentTime = 0.0
            for step in ledPattern {
                if task.isCancelled || !isRunning {  return }
                // Änderungen der Kreisfarben auf dem Hauptthread durchführen
                DispatchQueue.main.asyncAfter(deadline: .now() + currentTime) {
                    if task.isCancelled || !isRunning { return }
                    circleColors[0] = Color(red: Double(step.led1R) / 255.0, green: Double(step.led1G) / 255.0, blue: Double(step.led1B) / 255.0)
                    circleColors[1] = Color(red: Double(step.led2R) / 255.0, green: Double(step.led2G) / 255.0, blue: Double(step.led2B) / 255.0)
                    circleColors[2] = Color(red: Double(step.led3R) / 255.0, green: Double(step.led3G) / 255.0, blue: Double(step.led3B) / 255.0)
                    circleColors[3] = Color(red: Double(step.led4R) / 255.0, green: Double(step.led4G) / 255.0, blue: Double(step.led4B) / 255.0)
                    circleColors[4] = Color(red: Double(step.led5R) / 255.0, green: Double(step.led5G) / 255.0, blue: Double(step.led5B) / 255.0)
                    circleColors[5] = Color(red: Double(step.led6R) / 255.0, green: Double(step.led6G) / 255.0, blue: Double(step.led6B) / 255.0)
                    circleColors[6] = Color(red: Double(step.led7R) / 255.0, green: Double(step.led7G) / 255.0, blue: Double(step.led7B) / 255.0)
                    circleColors[7] = Color(red: Double(step.led8R) / 255.0, green: Double(step.led8G) / 255.0, blue: Double(step.led8B) / 255.0)
                    circleColors[8] = Color(red: Double(step.led9R) / 255.0, green: Double(step.led9G) / 255.0, blue: Double(step.led9B) / 255.0)
                    circleColors[9] = Color(red: Double(step.led10R) / 255.0, green: Double(step.led10G) / 255.0, blue: Double(step.led10B) / 255.0)
                    circleColors[10] = Color(red: Double(step.led11R) / 255.0, green: Double(step.led11G) / 255.0, blue: Double(step.led11B) / 255.0)
                    circleColors[11] = Color(red: Double(step.led12R) / 255.0, green: Double(step.led12G) / 255.0, blue: Double(step.led12B) / 255.0)
                    circleColors[12] = Color(red: Double(step.led13R) / 255.0, green: Double(step.led13G) / 255.0, blue: Double(step.led13B) / 255.0)
                    circleColors[13] = Color(red: Double(step.led14R) / 255.0, green: Double(step.led14G) / 255.0, blue: Double(step.led14B) / 255.0)
                    circleColors[14] = Color(red: Double(step.led15R) / 255.0, green: Double(step.led15G) / 255.0, blue: Double(step.led15B) / 255.0)
                    circleColors[15] = Color(red: Double(step.led16R) / 255.0, green: Double(step.led16G) / 255.0, blue: Double(step.led16B) / 255.0)
                    circleColors[16] = Color(red: Double(step.led17R) / 255.0, green: Double(step.led17G) / 255.0, blue: Double(step.led17B) / 255.0)
                    circleColors[17] = Color(red: Double(step.led18R) / 255.0, green: Double(step.led18G) / 255.0, blue: Double(step.led18B) / 255.0)
                    circleColors[18] = Color(red: Double(step.led19R) / 255.0, green: Double(step.led19G) / 255.0, blue: Double(step.led19B) / 255.0)
                    circleColors[19] = Color(red: Double(step.led20R) / 255.0, green: Double(step.led20G) / 255.0, blue: Double(step.led20B) / 255.0)
                    for i in 0...circleColors.count - 1 {
                        if circleColors[i] == .black {
                            circleColors[i] = .gray
                        }
                    }
                }
                // Nach der Verzögerung wird die Farbe zurückgesetzt
                currentTime += step.duration * (1.1 - speed)
                DispatchQueue.main.asyncAfter(deadline: .now() + currentTime) {
                    if task.isCancelled || !isRunning { return }
                    for i in 0...circleColors.count - 1 {
                        circleColors[i] = .gray
                    }
                }
            }
        }
        
        currentTask = task
        DispatchQueue.main.async(execute: task)
    }
    
    func showPattern(version: Int, speed: Double, isBouncing: Bool) {
        var ledPattern = patternManager.testPattern
        switch version {
            case 11: ledPattern = patternManager.threeSnakePattern
            case 12: ledPattern = patternManager.doubleSnakePattern
            case 13: ledPattern = patternManager.multiColorSnakePattern
            case 21: ledPattern = patternManager.smoothFadePattern
            case 22: ledPattern = patternManager.meteorFadePattern
            case 31: ledPattern = patternManager.rainPattern
            case 32: ledPattern = patternManager.sunrisePattern
            case 33: ledPattern = patternManager.wavePattern
            case 34: ledPattern = patternManager.firePattern
            case 41: ledPattern = patternManager.yellowFusionPattern
            case 42: ledPattern = patternManager.purpleFusionPattern
            case 43: ledPattern = patternManager.cyanFusionPattern
            case 44: ledPattern = patternManager.whiteFusionPattern
            case 51: ledPattern = patternManager.cornerPattern
            case 52: ledPattern = patternManager.fillingPattern
            default: break
        }
        var task2: DispatchWorkItem!
        currentTask2?.cancel()
        currentTask2 = nil
        if isBouncing {
            task2 = DispatchWorkItem {
                if task2.isCancelled { return }
                showPatternHelper(ledPattern: ledPattern, speed: speed, isBouncing: isBouncing)
                if task2.isCancelled { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + getTotalDuration(version: version, speed: speed)) {
                    if task2.isCancelled { return }
                    self.showPatternHelper(ledPattern: ledPattern.reversed(), speed: speed, isBouncing: isBouncing)
                }
            }
            currentTask2 = task2
            DispatchQueue.main.async(execute: task2)
        }
        else {
            showPatternHelper(ledPattern: ledPattern, speed: speed, isBouncing: isBouncing)
        }
    }
    
    // Funktion zum Berechnen der Gesamtdauer eines Musters
    func getTotalDuration(version: Int, speed: Double) -> TimeInterval {
        var ledPattern = patternManager.testPattern
        switch version {
            case 11: ledPattern = patternManager.threeSnakePattern
            case 12: ledPattern = patternManager.doubleSnakePattern
            case 13: ledPattern = patternManager.multiColorSnakePattern
            case 21: ledPattern = patternManager.smoothFadePattern
            case 22: ledPattern = patternManager.meteorFadePattern
            case 31: ledPattern = patternManager.rainPattern
            case 32: ledPattern = patternManager.sunrisePattern
            case 33: ledPattern = patternManager.wavePattern
            case 34: ledPattern = patternManager.firePattern
            case 41: ledPattern = patternManager.yellowFusionPattern
            case 42: ledPattern = patternManager.purpleFusionPattern
            case 43: ledPattern = patternManager.cyanFusionPattern
            case 44: ledPattern = patternManager.whiteFusionPattern
            case 51: ledPattern = patternManager.cornerPattern
            case 52: ledPattern = patternManager.fillingPattern
            default: break
        }
        return ledPattern.reduce(0.0) {
            $0 + $1.duration * (1.1 - speed)
        }
    }
    
    // Kategorien und Muster
    let categories = ["snake", "fade", "nature", "fusion", "section"]
    let patterns = [    "snake": ["small", "double", "multi-color"],
                        "fade": ["smooth", "meteor"],
                        "nature": ["rain", "sunrise", "wave", "fire"],
                        "fusion": ["yellow", "purple", "cyan", "white"],
                        "section": ["corner", "filling"]
    ]
    
    // Füge hier alle Pattern hinzu wo die Farbe veränderbar sein soll!
    @State private var patternColors: [String: Color] = [
        "small": .white,
        "double": .white,
        "rain": .white,
        "sunrise": .white,
        "wave": .white,
        "corner": .white,
        "filling": .white
    ]
    
    // Funktion zum Muster speichern
    func savePattern(patternName: String, index: Int, speed: Double) {
        let patternArray = patterns[selectedCategory!]
        let patternName = patternArray![index]
        let newFavorite = FavoritePattern(name: patternName, categoryName: selectedCategory!, version: getVersion(category: selectedCategory!, pattern: patternName)!, speed: speed, isBouncing: isBouncing)
        favoritePatterns.append(newFavorite)
    }
    
    func removePattern(patternName: String) {
        if let index = favoritePatterns.firstIndex(where: { $0.name == patternName }) {
            favoritePatterns.remove(at: index)
        }
    }
    
    func getCategory(pattern: String) -> String {
        var category = ""
        for pat in patterns {
            if pat.value.contains(pattern) {
                category = pat.key
                break
            }
        }
        return category
    }
    
    func getVersion(category: String, pattern: String) -> Int? {
        guard let categoryIndex = categories.firstIndex(of: category) else {
            print("Category not found")
            return nil
        }
        guard let patternIndex = patterns[category]?.firstIndex(of: pattern) else {
            print("Pattern not found in the given category")
            return nil
        }
        let versionPrefix = categoryIndex + 1
        let versionSuffix = patternIndex + 1
        let versionString = "\(versionPrefix)\(versionSuffix)"
        guard let version = Int(versionString) else {
            print("Failed to convert version string to integer")
            return nil
        }
        return version
    }
    
    @State private var color: Color = .white
    
    func updatePatternColor(with color: Color, version: Int) {
        let colorComponents = color.rgbComponents
        let red = UInt8(colorComponents.0 * 255)
        let green = UInt8(colorComponents.1 * 255)
        let blue = UInt8(colorComponents.2 * 255)
        
        var ledPattern = patternManager.testPattern
        switch version {
            case 11: ledPattern = patternManager.threeSnakePattern
            case 12: ledPattern = patternManager.doubleSnakePattern
            case 31: ledPattern = patternManager.rainPattern
            case 32: ledPattern = patternManager.sunrisePattern
            case 33: ledPattern = patternManager.wavePattern
            case 51: ledPattern = patternManager.cornerPattern
            case 52: ledPattern = patternManager.fillingPattern
            default: break
        }
        
        for i in 0..<ledPattern.count {
            ledPattern[i] = replacingNonZeroColors(color: (red, green, blue), step: ledPattern[i])
        }
        
        switch version {
            case 11: patternManager.threeSnakePattern = ledPattern
            case 12: patternManager.doubleSnakePattern = ledPattern
            case 31: patternManager.rainPattern = ledPattern
            case 32: patternManager.sunrisePattern = ledPattern
            case 33: patternManager.wavePattern = ledPattern
            case 51: patternManager.cornerPattern = ledPattern
            case 52: patternManager.fillingPattern = ledPattern
            default: break
        }
    }
    
    func replacingNonZeroColors(color: (UInt8, UInt8, UInt8),
            step: (ledIndex1: UInt8, led1R: UInt8, led1G: UInt8, led1B: UInt8,
                   ledIndex2: UInt8, led2R: UInt8, led2G: UInt8, led2B: UInt8,
                   ledIndex3: UInt8, led3R: UInt8, led3G: UInt8, led3B: UInt8,
                   ledIndex4: UInt8, led4R: UInt8, led4G: UInt8, led4B: UInt8,
                   ledIndex5: UInt8, led5R: UInt8, led5G: UInt8, led5B: UInt8,
                   ledIndex6: UInt8, led6R: UInt8, led6G: UInt8, led6B: UInt8,
                   ledIndex7: UInt8, led7R: UInt8, led7G: UInt8, led7B: UInt8,
                   ledIndex8: UInt8, led8R: UInt8, led8G: UInt8, led8B: UInt8,
                   ledIndex9: UInt8, led9R: UInt8, led9G: UInt8, led9B: UInt8,
                   ledIndex10: UInt8, led10R: UInt8, led10G: UInt8, led10B: UInt8,
                   ledIndex11: UInt8, led11R: UInt8, led11G: UInt8, led11B: UInt8,
                   ledIndex12: UInt8, led12R: UInt8, led12G: UInt8, led12B: UInt8,
                   ledIndex13: UInt8, led13R: UInt8, led13G: UInt8, led13B: UInt8,
                   ledIndex14: UInt8, led14R: UInt8, led14G: UInt8, led14B: UInt8,
                   ledIndex15: UInt8, led15R: UInt8, led15G: UInt8, led15B: UInt8,
                   ledIndex16: UInt8, led16R: UInt8, led16G: UInt8, led16B: UInt8,
                   ledIndex17: UInt8, led17R: UInt8, led17G: UInt8, led17B: UInt8,
                   ledIndex18: UInt8, led18R: UInt8, led18G: UInt8, led18B: UInt8,
                   ledIndex19: UInt8, led19R: UInt8, led19G: UInt8, led19B: UInt8,
                   ledIndex20: UInt8, led20R: UInt8, led20G: UInt8, led20B: UInt8,
                   duration: TimeInterval)
        ) -> (ledIndex1: UInt8, led1R: UInt8, led1G: UInt8, led1B: UInt8,
              ledIndex2: UInt8, led2R: UInt8, led2G: UInt8, led2B: UInt8,
              ledIndex3: UInt8, led3R: UInt8, led3G: UInt8, led3B: UInt8,
              ledIndex4: UInt8, led4R: UInt8, led4G: UInt8, led4B: UInt8,
              ledIndex5: UInt8, led5R: UInt8, led5G: UInt8, led5B: UInt8,
              ledIndex6: UInt8, led6R: UInt8, led6G: UInt8, led6B: UInt8,
              ledIndex7: UInt8, led7R: UInt8, led7G: UInt8, led7B: UInt8,
              ledIndex8: UInt8, led8R: UInt8, led8G: UInt8, led8B: UInt8,
              ledIndex9: UInt8, led9R: UInt8, led9G: UInt8, led9B: UInt8,
              ledIndex10: UInt8, led10R: UInt8, led10G: UInt8, led10B: UInt8,
              ledIndex11: UInt8, led11R: UInt8, led11G: UInt8, led11B: UInt8,
              ledIndex12: UInt8, led12R: UInt8, led12G: UInt8, led12B: UInt8,
              ledIndex13: UInt8, led13R: UInt8, led13G: UInt8, led13B: UInt8,
              ledIndex14: UInt8, led14R: UInt8, led14G: UInt8, led14B: UInt8,
              ledIndex15: UInt8, led15R: UInt8, led15G: UInt8, led15B: UInt8,
              ledIndex16: UInt8, led16R: UInt8, led16G: UInt8, led16B: UInt8,
              ledIndex17: UInt8, led17R: UInt8, led17G: UInt8, led17B: UInt8,
              ledIndex18: UInt8, led18R: UInt8, led18G: UInt8, led18B: UInt8,
              ledIndex19: UInt8, led19R: UInt8, led19G: UInt8, led19B: UInt8,
              ledIndex20: UInt8, led20R: UInt8, led20G: UInt8, led20B: UInt8,
              duration: TimeInterval) {
        var newStep = step
        if step.led1R > 0 || step.led1G > 0 || step.led1B > 0 {
            newStep.led1R = color.0
            newStep.led1G = color.1
            newStep.led1B = color.2
        }
        if step.led2R > 0 || step.led2G > 0 || step.led2B > 0 {
            newStep.led2R = color.0
            newStep.led2G = color.1
            newStep.led2B = color.2
        }
        if step.led3R > 0 || step.led3G > 0 || step.led3B > 0 {
            newStep.led3R = color.0
            newStep.led3G = color.1
            newStep.led3B = color.2
        }
        if step.led4R > 0 || step.led4G > 0 || step.led4B > 0 {
            newStep.led4R = color.0
            newStep.led4G = color.1
            newStep.led4B = color.2
        }
        if step.led5R > 0 || step.led5G > 0 || step.led5B > 0 {
            newStep.led5R = color.0
            newStep.led5G = color.1
            newStep.led5B = color.2
        }
        if step.led6R > 0 || step.led6G > 0 || step.led6B > 0 {
            newStep.led6R = color.0
            newStep.led6G = color.1
            newStep.led6B = color.2
        }
        if step.led7R > 0 || step.led7G > 0 || step.led7B > 0 {
            newStep.led7R = color.0
            newStep.led7G = color.1
            newStep.led7B = color.2
        }
        if step.led8R > 0 || step.led8G > 0 || step.led8B > 0 {
            newStep.led8R = color.0
            newStep.led8G = color.1
            newStep.led8B = color.2
        }
        if step.led9R > 0 || step.led9G > 0 || step.led9B > 0 {
            newStep.led9R = color.0
            newStep.led9G = color.1
            newStep.led9B = color.2
        }
        if step.led10R > 0 || step.led10G > 0 || step.led10B > 0 {
            newStep.led10R = color.0
            newStep.led10G = color.1
            newStep.led10B = color.2
        }
        if step.led11R > 0 || step.led11G > 0 || step.led11B > 0 {
            newStep.led11R = color.0
            newStep.led11G = color.1
            newStep.led11B = color.2
        }
        if step.led12R > 0 || step.led12G > 0 || step.led12B > 0 {
            newStep.led12R = color.0
            newStep.led12G = color.1
            newStep.led12B = color.2
        }
        if step.led13R > 0 || step.led13G > 0 || step.led13B > 0 {
            newStep.led13R = color.0
            newStep.led13G = color.1
            newStep.led13B = color.2
        }
        if step.led14R > 0 || step.led14G > 0 || step.led14B > 0 {
            newStep.led14R = color.0
            newStep.led14G = color.1
            newStep.led14B = color.2
        }
        if step.led15R > 0 || step.led15G > 0 || step.led15B > 0 {
            newStep.led15R = color.0
            newStep.led15G = color.1
            newStep.led15B = color.2
        }
        if step.led16R > 0 || step.led16G > 0 || step.led16B > 0 {
            newStep.led16R = color.0
            newStep.led16G = color.1
            newStep.led16B = color.2
        }
        if step.led17R > 0 || step.led17G > 0 || step.led17B > 0 {
            newStep.led17R = color.0
            newStep.led17G = color.1
            newStep.led17B = color.2
        }
        if step.led18R > 0 || step.led18G > 0 || step.led18B > 0 {
            newStep.led18R = color.0
            newStep.led18G = color.1
            newStep.led18B = color.2
        }
        if step.led19R > 0 || step.led19G > 0 || step.led19B > 0 {
            newStep.led19R = color.0
            newStep.led19G = color.1
            newStep.led19B = color.2
        }
        if step.led20R > 0 || step.led20G > 0 || step.led20B > 0 {
            newStep.led20R = color.0
            newStep.led20G = color.1
            newStep.led20B = color.2
        }
        return newStep
    }
    
    struct RingSegment: Shape {
        var startAngle: Angle
        var endAngle: Angle
        var thickness: CGFloat
        
        func path(in rect: CGRect) -> Path {
            let radius = min(rect.width, rect.height) / 2
            let center = CGPoint(x: rect.midX, y: rect.midY)
            var path = Path()
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            path.addArc(center: center, radius: radius - thickness, startAngle: endAngle, endAngle: startAngle, clockwise: true)
            path.closeSubpath()
            return path
        }
    }
    
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var selectedImage: UIImage?
        
        func makeUIViewController(context: Context) -> PHPickerViewController {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = context.coordinator
            return picker
        }
        
        func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, PHPickerViewControllerDelegate {
            var parent: ImagePicker
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
            func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
                picker.dismiss(animated: true)
                if let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { (image, error) in
                        DispatchQueue.main.async {
                            self.parent.selectedImage = image as? UIImage
                        }
                    }
                }
            }
        }
    }
    
    // Diese Funktion wird nach der Bildauswahl aufgerufen
    func processSelectedImage() {
        if let uiImage = selectedImage {
            let width = Int(uiImage.size.width)
            let height = Int(uiImage.size.height)
            // Berechne Farben für jedes Randsegment des Displays
            var newColorsTemp: [Color] = []
            
            for index in 0...19 {
                let color = averageColorForSegment(image: uiImage, segmentIndex: index, totalSegmentsTopBottom: 4, totalSegmentsLeftRight: 6, width: width, height: height)
                newColorsTemp.append(color)
            }
            
            // Randsegmente den Vorschau-Kreisen zuweisen
            var newColors: [Color] = []
            newColors.append(newColorsTemp[17])
            newColors.append(newColorsTemp[18])
            newColors.append(newColorsTemp[19])
            newColors.append(newColorsTemp[4])
            newColors.append(newColorsTemp[5])
            newColors.append(newColorsTemp[6])
            newColors.append(newColorsTemp[7])
            newColors.append(newColorsTemp[13])
            newColors.append(newColorsTemp[12])
            newColors.append(newColorsTemp[11])
            newColors.append(newColorsTemp[10])
            newColors.append(newColorsTemp[9])
            newColors.append(newColorsTemp[8])
            newColors.append(newColorsTemp[3])
            newColors.append(newColorsTemp[2])
            newColors.append(newColorsTemp[1])
            newColors.append(newColorsTemp[0])
            newColors.append(newColorsTemp[14])
            newColors.append(newColorsTemp[15])
            newColors.append(newColorsTemp[16])
            circleColors = newColors
        }
        bluetoothManager.sendWallpaper(circleColors: circleColors)
    }
        
    struct SearchBarView: View {
        @State private var searchText = ""
        @State private var showSearchBar = false
        @Binding var selectedCategory: String?
        @Binding var selectedPattern: String?

        let categories: [String]
        let patterns: [String: [String]]

        @State private var filteredResults: [String] = []

        var body: some View {
            ZStack(alignment: .center) {
                VStack(alignment: .center) {
                    HStack(alignment: .center) {
                        // Lupe als Button, der die Suchleiste öffnet
                        Button(action: {
                            withAnimation {
                                showSearchBar.toggle()
                                if showSearchBar {
                                    searchText = "" // Setzt den Suchtext auf leer zurück
                                    filteredResults = categories + patterns.flatMap { $0.value }
                                }
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.blue)
                                .padding()
                        }
                        .frame(alignment: .leading)

                        // Suchleiste anzeigen, wenn showSearchBar true ist
                        if showSearchBar {
                            TextField("Search...", text: $searchText)
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(8)
                                .frame(width: 300) // Breite der Suchleiste
                                .onChange(of: searchText) { newValue in
                                    performLiveSearch()
                                }
                        }

                        Spacer()
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .center)

                    // Liste der Suchergebnisse direkt unter der Suchleiste
                    if showSearchBar && !filteredResults.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 5) {
                                // Zeige die gefilterten Ergebnisse
                                ForEach(filteredResults, id: \.self) { result in
                                    Button(action: {
                                        // Überprüfen, ob das Result eine Kategorie oder ein Pattern ist
                                        if categories.contains(result) {
                                            selectedCategory = result
                                            selectedPattern = nil
                                        } else {
                                            for (category, patternList) in patterns {
                                                if patternList.contains(result) {
                                                    selectedCategory = category
                                                    selectedPattern = result
                                                    break
                                                }
                                            }
                                        }
                                        withAnimation {
                                            showSearchBar = false // Schließe die Suchleiste bei Auswahl
                                        }
                                    }) {
                                        Text(result)
                                            .padding(10)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.white)
                                            .cornerRadius(8)
                                            .shadow(radius: 2)
                                            .padding(.horizontal, 10)
                                    }
                                }
                            }
                            .padding(.vertical, 10)
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .frame(width: 300) // Breite und maximale Höhe festlegen
                        .padding(.top, 5)
                        .frame(maxWidth: .infinity, alignment: .center) // Mittig ausgerichtet
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

                // Decke den Rest des Bildschirms ab, um Klicks außerhalb der Suchleiste zu erkennen
                if showSearchBar {
                    Color.black.opacity(0.001) // Unsichtbare Fläche für Klickerkennung
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showSearchBar = false
                            }
                        }
                        .zIndex(-1)
                }
            }
            .zIndex(1)
        }

        // Live-Suche durchführen, während der Nutzer tippt
        func performLiveSearch() {
            let searchTextLowercased = searchText.lowercased()

            // Kombiniere Kategorien und Muster für die Live-Suche
            filteredResults = (categories + patterns.flatMap { $0.value }).filter { $0.lowercased().hasPrefix(searchTextLowercased) }
        }
    }

    
    @State private var showFavoritesOverlay = false // Variable to show/hide the overlay
    @State private var notificationPattern: String? = nil // Variable to store selected notification pattern
    @State private var selectedBell: String? = nil // Track selected bell
    @State private var searchText: String = "" // Text for the search query
    
    let outerCircleRadius: CGFloat = 100
    let thickness: CGFloat = 15
    let segmentCount = 20
    
    //View Elemente
    var body: some View {
        NavigationView {
            ZStack {
                Image(selectedBackground)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .zIndex(-1)
                VStack {
                    // Kreise in einem Kreis anordnen
                    ZStack {
                        ForEach(0..<segmentCount) { index in
                            let startAngle = Angle(degrees: Double(index) * (360.0 / Double(segmentCount)))
                            let endAngle = Angle(degrees: Double(index + 1) * (360.0 / Double(segmentCount)))
                            RingSegment(startAngle: startAngle, endAngle: endAngle, thickness: thickness)
                                .fill(circleColors[index])
                        }
                    }
                    .frame(width: outerCircleRadius * 2, height: outerCircleRadius * 2)
                    // Button für Farbänderung basierend auf den Randsegmenten
                    Button(action: {
                        showImagePicker = true // Zeige den Image Picker
                    }) {
                        HStack {
                            Text("Wallpaper Colors")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .sheet(isPresented: $showImagePicker, onDismiss: processSelectedImage) {
                                    ImagePicker(selectedImage: $selectedImage)
                                }
                            // Notification Button with custom overlay
                            Button(action: {
                                if favoritePatterns.count > 0 {
                                    showFavoritesOverlay = true // Show the overlay
                                }
                                else {
                                    showFavoritesOverlay = false
                                    notificationPattern = nil
                                    selectedBell = nil
                                }
                            }) {
                                Image(systemName: "bell.fill")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 30))
                            }
                            .padding(.top, 10)
                        }
                    }
                        // Bouncing Button
                        Button(action: {
                            isBouncing.toggle()
                        }) {
                            Image(systemName: isBouncing ? "arrow.left.and.right.circle.fill" : "arrow.left.and.right.circle")
                                .foregroundColor(isBouncing ? .green : .gray)
                                .font(.system(size: 30))
                        }
                    // Speed Regler
                    VStack {
                        HStack {
                            Spacer(minLength: 20)
                            Slider(value: $speed, in: 0.01...1.0, step: 0.01)
                                .accentColor(.green)
                                .padding(.horizontal)
                                .padding(.bottom, 10)
                            Spacer(minLength: 20)
                        }
                        Text("Speed: \(Int(speed * 100))%")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    
                
                    // Search bar for categories and patterns
                    SearchBarView(selectedCategory: $selectedCategory, selectedPattern: $selectedPattern, categories: categories, patterns: patterns)
                    
                    // Kategorie und Muster Auswahl
                    VStack {
                        ScrollView(.horizontal) {
                            HStack(spacing: 10) {
                                Button(action: {
                                    selectedCategory = "Favorites"
                                    selectedPattern = nil
                                }) {
                                    Text("Favorites")
                                        .padding()
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .frame(width: 85, height: 85)
                                        .background(selectedCategory == "Favorites" ? Color.green : Color.black)
                                        .cornerRadius(8)
                                }
                                ForEach(categories, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category
                                        selectedPattern = nil
                                    }) {
                                        Text(category)
                                            .padding()
                                            .font(.system(size: 14))
                                            .foregroundColor(.white)
                                            .frame(width: 85, height: 85)
                                            .background(selectedCategory == category ? Color.green : Color.black)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding(.leading, 15)
                            .padding(.horizontal)
                        }
                        .padding(.trailing, 15)
                        if let selectedCategory = selectedCategory {
                            ScrollView {
                                VStack(spacing: 2) {
                                    let patternsToShow: [(String, String, Double, Bool)] = selectedCategory == "Favorites" ? favoritePatterns.map { ($0.name, $0.categoryName, $0.speed, $0.isBouncing) } : (patterns[selectedCategory] ?? []).map { ($0, selectedCategory, speed, isBouncing) }
                                    ForEach(patternsToShow.indices, id: \.self) { index in
                                        let patternData = patternsToShow[index]
                                        let patternName = patternData.0
                                        let categoryName = patternData.1
                                        let speedTemp = patternData.2
                                        let isBouncingTemp = patternData.3
                                        HStack {
                                            Button(action: {
                                                if favoritePatterns.contains(where: { $0.name == patternName }) {
                                                    removePattern(patternName: patternName)
                                                    favorites[patternName] = false
                                                } else {
                                                    favorites[patternName, default: false].toggle()
                                                    if favorites[patternName] == true {
                                                        savePattern(patternName: patternName, index: index, speed: speedTemp)
                                                    } else {
                                                        removePattern(patternName: patternName)
                                                    }
                                                }
                                            }) {
                                                Image(systemName: favorites[patternName, default: false] ? "heart.fill" : "heart")
                                                    .padding()
                                                    .foregroundColor(.white)
                                            }
                                            Button(action: {
                                                selectedPattern = patternName
                                                let ver = getVersion(category: categoryName, pattern: patternName)
                                                bluetoothManager.sendPattern(speed: speedTemp, version: ver!, loop: !isBouncingTemp, patternManager: patternManager)
                                            }) {
                                                HStack {
                                                    Text(patternName)
                                                    Spacer()
                                                }
                                                .padding()
                                                .foregroundColor(.primary)
                                                .frame(maxWidth: .infinity)
                                            }
                                            .background(selectedPattern == patternName ? Color.green : Color.clear)
                                            .cornerRadius(8)
                                            if patternColors.keys.contains(patternName) {
                                                ColorPicker("", selection: Binding(
                                                    get: { patternColors[patternName] ?? .white },
                                                    set: { newColor in
                                                        patternColors[patternName] = newColor
                                                        updatePatternColor(with: newColor, version: getVersion(category: getCategory(pattern: patternName), pattern: patternName)!)
                                                    })
                                                )
                                                .labelsHidden()
                                                .frame(width: 30, height: 30)
                                                .padding(.leading, 8)
                                            }
                                            Button(action: {
                                                let ver = getVersion(category: categoryName, pattern: patternName)
                                                currentTask?.cancel()
                                                showPattern(version: ver!, speed: speedTemp, isBouncing: isBouncingTemp)
                                            }) {
                                                Image(systemName: "eye")
                                                    .padding()
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        .cornerRadius(8)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.top, 30)
                // Custom Overlay for Favorite Patterns
                if showFavoritesOverlay {
                    // Klickbare Fläche zum Schließen des Popovers
                    Color.black.opacity(0.6)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showFavoritesOverlay = false // Schließt das Overlay, wenn außerhalb des Popovers geklickt wird
                        }
                    // Popover-Inhalt
                    VStack {
                        Text("Favorite Patterns")
                            .font(.headline)
                            .padding()
                        // Display list of favorite patterns
                        ScrollView {
                            ForEach(favoritePatterns, id: \.name) { pattern in
                                Button(action: {
                                    if selectedBell == pattern.name {
                                        // Wenn die gleiche Glocke erneut ausgewählt wird
                                        selectedBell = nil
                                        notificationPattern = nil
                                    } else {
                                        // Wenn eine andere Glocke ausgewählt wird
                                        notificationPattern = pattern.name
                                        selectedBell = pattern.name
                                    }
                                    // Das Popover bleibt geöffnet, da wir es hier nicht schließen
                                }) {
                                    HStack {
                                        Text(pattern.name)
                                        Spacer()
                                        Image(systemName: selectedBell == pattern.name ? "bell.fill" : "bell")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                        }
                        .frame(width: 300, height: 400)
                        .background(Color.white)
                        .cornerRadius(15)
                        Button(action: {
                            showFavoritesOverlay = false
                        }) {
                            Text("Close")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                        .padding(.top, 20)
                    }
                    .frame(width: 300, height: 400)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .zIndex(1)
                }
            }
        }
    }
}
