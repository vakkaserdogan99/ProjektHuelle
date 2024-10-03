//  PatternView.swift
//  NeueBluetooth

import SwiftUI


struct FavoritePattern: Identifiable, Codable {
    var id = UUID()
    var name: String
    var categoryName: String
    var version: Int
    var speed: Double
    var color: Color
    var isBouncing: Bool
    
    enum CodingKeys: String, CodingKey {
            case id, name, categoryName, version, speed, color, isBouncing
        }
    
    private var colorComponents: [CGFloat] {
            let uiColor = UIColor(color)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return [red, green, blue, alpha]
        }
    
    init(id: UUID = UUID(), name: String, categoryName: String, version: Int, speed: Double, color: Color, isBouncing: Bool) {
            self.id = id
            self.name = name
            self.categoryName = categoryName
            self.version = version
            self.speed = speed
            self.color = color
            self.isBouncing = isBouncing
        }
    
    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
            try container.encode(categoryName, forKey: .categoryName)
            try container.encode(version, forKey: .version)
            try container.encode(speed, forKey: .speed)
            try container.encode(colorComponents, forKey: .color)
            try container.encode(isBouncing, forKey: .isBouncing)
        }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(UUID.self, forKey: .id)
            name = try container.decode(String.self, forKey: .name)
            categoryName = try container.decode(String.self, forKey: .categoryName)
            version = try container.decode(Int.self, forKey: .version)
            speed = try container.decode(Double.self, forKey: .speed)
            let colorComponents = try container.decode([CGFloat].self, forKey: .color)
            color = Color(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], opacity: colorComponents[3])
            isBouncing = try container.decode(Bool.self, forKey: .isBouncing)
        }
}

struct PatternView: View {
    @EnvironmentObject var patternManager: PatternManager
   
    //Bluetooth, Design und Sprache
    @EnvironmentObject var bluetoothManager: BluetoothManager
    @AppStorage("selectedBackground") var selectedBackground = "background1"
    @EnvironmentObject var languageManager: LanguageManager
   
    //Für Favoriten Button
    @State private var favorites: [String: Bool] = [:] // Dictionary to track favorite status for each pattern
   
    // Farbe für die Kreise
    @State private var circleColors: [Color] = Array(repeating: .gray, count: 20)
   
    // Radius des äußeren Kreises
    let outerCircleRadius: CGFloat = 100.0
   
    // Ausgewählte Kategorie und Muster
    @State private var selectedCategory: String?
    @State private var selectedPattern: String?
   
    // Speed
    @State private var speed: Double = 0.5
    @State private var currentTime: Double = 0.0
   
    // Zustandsvariablen für links-rechts bounce
    @State private var isBouncing: Bool = false
    @State private var isFavorite: Bool = false

   
    // Favoriten
    
    @State private var favoriteName: String = ""
    @AppStorage("favoritePatterns") private var favoritePatternsData: Data = Data()
    @State private var favoritePatterns: [FavoritePattern] = []
   
    @State private var currentTask: DispatchWorkItem?
    @State private var currentTask2: DispatchWorkItem?
    
    @State private var choosedColor: Color = .red
    @State private var didColorChange: Bool = false
    
   
    func showPatternHelper(version: Int, ledPattern: [(ledIndex1: UInt8, led1R: UInt8, led1G: UInt8, led1B: UInt8, ledIndex2: UInt8, led2R: UInt8, led2G: UInt8, led2B: UInt8, ledIndex3: UInt8, led3R: UInt8, led3G: UInt8, led3B: UInt8, ledIndex4: UInt8, led4R: UInt8, led4G: UInt8, led4B: UInt8, ledIndex5: UInt8, led5R: UInt8, led5G: UInt8, led5B: UInt8, ledIndex6: UInt8, led6R: UInt8, led6G: UInt8, led6B: UInt8, ledIndex7: UInt8, led7R: UInt8, led7G: UInt8, led7B: UInt8, ledIndex8: UInt8, led8R: UInt8, led8G: UInt8, led8B: UInt8, ledIndex9: UInt8, led9R: UInt8, led9G: UInt8, led9B: UInt8, ledIndex10: UInt8, led10R: UInt8, led10G: UInt8, led10B: UInt8, ledIndex11: UInt8, led11R: UInt8, led11G: UInt8, led11B: UInt8, ledIndex12: UInt8, led12R: UInt8, led12G: UInt8, led12B: UInt8, ledIndex13: UInt8, led13R: UInt8, led13G: UInt8, led13B: UInt8, ledIndex14: UInt8, led14R: UInt8, led14G: UInt8, led14B: UInt8, ledIndex15: UInt8, led15R: UInt8, led15G: UInt8, led15B: UInt8, ledIndex16: UInt8, led16R: UInt8, led16G: UInt8, led16B: UInt8, ledIndex17: UInt8, led17R: UInt8, led17G: UInt8, led17B: UInt8, ledIndex18: UInt8, led18R: UInt8, led18G: UInt8, led18B: UInt8, ledIndex19: UInt8, led19R: UInt8, led19G: UInt8, led19B: UInt8, ledIndex20: UInt8, led20R: UInt8, led20G: UInt8, led20B: UInt8, duration: TimeInterval)], speed: Double, isBouncing: Bool) {
       
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
        var ledPattern = patternManager.randomPattern
        switch version {
            case 31: ledPattern = patternManager.fadePattern
            case 11: ledPattern = patternManager.threeSnakePattern
            case 41: ledPattern = patternManager.rainPattern
            default: break
        }
       
        var task2: DispatchWorkItem!

        currentTask2?.cancel()
        currentTask2 = nil

        if isBouncing {
            task2 = DispatchWorkItem {
                if task2.isCancelled { return }
                showPatternHelper(version: version, ledPattern: ledPattern, speed: speed, isBouncing: isBouncing)
                if task2.isCancelled { return }
               
                DispatchQueue.main.asyncAfter(deadline: .now() + getTotalDuration(ledPattern: ledPattern, speed: speed)) {
                    if task2.isCancelled { return }
                    self.showPatternHelper(version: version, ledPattern: ledPattern.reversed(), speed: speed, isBouncing: isBouncing)
                }
            }
            currentTask2 = task2
            DispatchQueue.main.async(execute: task2)
        }

        else {
            showPatternHelper(version: version, ledPattern: ledPattern, speed: speed, isBouncing: isBouncing)
        }
    }
   
   
    // Funktion zum Berechnen der Gesamtdauer eines Musters
    func getTotalDuration(ledPattern: [(ledIndex1: UInt8, led1R: UInt8, led1G: UInt8, led1B: UInt8, ledIndex2: UInt8, led2R: UInt8, led2G: UInt8, led2B: UInt8, ledIndex3: UInt8, led3R: UInt8, led3G: UInt8, led3B: UInt8, ledIndex4: UInt8, led4R: UInt8, led4G: UInt8, led4B: UInt8, ledIndex5: UInt8, led5R: UInt8, led5G: UInt8, led5B: UInt8, ledIndex6: UInt8, led6R: UInt8, led6G: UInt8, led6B: UInt8, ledIndex7: UInt8, led7R: UInt8, led7G: UInt8, led7B: UInt8, ledIndex8: UInt8, led8R: UInt8, led8G: UInt8, led8B: UInt8, ledIndex9: UInt8, led9R: UInt8, led9G: UInt8, led9B: UInt8, ledIndex10: UInt8, led10R: UInt8, led10G: UInt8, led10B: UInt8, ledIndex11: UInt8, led11R: UInt8, led11G: UInt8, led11B: UInt8, ledIndex12: UInt8, led12R: UInt8, led12G: UInt8, led12B: UInt8, ledIndex13: UInt8, led13R: UInt8, led13G: UInt8, led13B: UInt8, ledIndex14: UInt8, led14R: UInt8, led14G: UInt8, led14B: UInt8, ledIndex15: UInt8, led15R: UInt8, led15G: UInt8, led15B: UInt8, ledIndex16: UInt8, led16R: UInt8, led16G: UInt8, led16B: UInt8, ledIndex17: UInt8, led17R: UInt8, led17G: UInt8, led17B: UInt8, ledIndex18: UInt8, led18R: UInt8, led18G: UInt8, led18B: UInt8, ledIndex19: UInt8, led19R: UInt8, led19G: UInt8, led19B: UInt8, ledIndex20: UInt8, led20R: UInt8, led20G: UInt8, led20B: UInt8, duration: TimeInterval)], speed: Double) -> TimeInterval {
       
        return ledPattern.reduce(0.0) {
            $0 + $1.duration * (1.1 - speed)
        }
    }
   
   
    // Kategorien und Muster
    let categories = ["snake", "random", "fade", "nature"]
    
    let patterns = [        "snake": ["small"],
                            "random": ["version 1", "version 2", "version 3"],
                            "fade": ["3-color", "5-color", "7-color"],
                            "nature": ["rain", "sun", "wind"]
    ]
   
   
    // Funktion zum Muster speichern
    func savePattern(patternName: String, index: Int, speed: Double, color: Color) {
        let patternArray = patterns[selectedCategory!]
        let patternName = patternArray![index]
        let isFavorite = true
        let newFavorite = FavoritePattern(name: patternName, categoryName: selectedCategory!, version: getVersion(category: selectedCategory!, pattern: patternName)!, speed: speed, color: color, isBouncing: isBouncing)
        favoritePatterns.append(newFavorite)
        saveFavoritePatterns()
    }
    
    func removePattern(patternName: String) {
        if let index = favoritePatterns.firstIndex(where: { $0.name == patternName }) {
            favoritePatterns.remove(at: index)
        }
        saveFavoritePatterns()
    }
    
    private func saveFavoritePatterns() {
        if let encoded = try? JSONEncoder().encode(favoritePatterns) {
            favoritePatternsData = encoded
        }
    }

    private func loadFavoritePatterns() {
        if let decoded = try? JSONDecoder().decode([FavoritePattern].self, from: favoritePatternsData) {
            favoritePatterns = decoded
        }
    }
   
    func getFavorite(name: String) -> FavoritePattern {
        var favTemp = FavoritePattern(name: "", categoryName: "", version: 0, speed: 0.0, color: .black, isBouncing: false)
        for fav in favoritePatterns {
            if fav.name == name {
                favTemp = fav
            }
        }
        return favTemp
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
   
      
    func updatePatternColor(with color: Color) {
        let colorComponents = color.rgbComponents
        let red = UInt8(colorComponents.0 * 255)
        let green = UInt8(colorComponents.1 * 255)
        let blue = UInt8(colorComponents.2 * 255)
       
        for i in 0..<patternManager.threeSnakePattern.count {
            patternManager.threeSnakePattern[i] = replacingNonZeroColors(color: (red, green, blue), step: patternManager.threeSnakePattern[i])
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
   

    // View Elemente
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
                        ForEach(0..<20) { index in
                            let angle = Angle(degrees: Double(index) * (360.0 / 20))
                            let x = outerCircleRadius * CGFloat(cos(angle.radians))
                            let y = outerCircleRadius * CGFloat(sin(angle.radians))

                            Circle()
                                .fill(circleColors[index])
                                .frame(width: 30, height: 30)
                                .offset(x: x, y: y)
                        }
                    }
                    .frame(width: outerCircleRadius * 2, height: outerCircleRadius * 2)

                    Button(action: {
                        isBouncing.toggle()
                    }) {
                        Image(systemName: isBouncing ? "arrow.left.and.right.circle.fill" : "arrow.left.and.right.circle")
                            .foregroundColor(isBouncing ? .green : .gray)
                            .font(.system(size: 30))
                    }
                    .padding(.top, 10)

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

                    // Kategorie und Muster Auswahl
                    VStack {
                        ScrollView(.horizontal) {
                            HStack(spacing: 10) {
                                // Adding the "Favorites" button at the beginning
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
                                        .multilineTextAlignment(.center)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5) // Erlaube dem Text, bis auf 50% seiner ursprünglichen Größe zu skaliert werden
                                }

                                ForEach(categories, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category
                                        selectedPattern = nil
                                    }) {
                                        Text(languageManager.localizedString(forKey: category))
                                            .padding()
                                            .font(.system(size: 14))
                                            .foregroundColor(.white)
                                            .frame(width: 85, height: 85) // Set both width and height to the same value
                                            .background(selectedCategory == category ? Color.green : Color.black)
                                            .cornerRadius(8)
                                            .multilineTextAlignment(.center) // Center-align the text
                                            .lineLimit(1) // Allow unlimited lines
                                            .minimumScaleFactor(0.5) // Erlaube dem Text, bis auf 50% seiner ursprünglichen Größe zu skaliert werden

                                    }
                                }
                            }
                            .padding(.leading, 15) // Add padding to the left side
                            .padding(.horizontal) // This line ensures there is padding on both sides
                        }
                        .padding(.trailing, 15) // Add padding to the left side

                        if let selectedCategory = selectedCategory {
                            ScrollView {
                                VStack(spacing: 2) {
                                    // Wenn die ausgewählte Kategorie "Favorites" ist, nur favoritePatterns anzeigen
                                    let patternsToShow: [(String, String, Double, Bool, Color)] = selectedCategory == "Favorites" ? favoritePatterns.map { ($0.name, $0.categoryName, $0.speed, $0.isBouncing, $0.color) } : (patterns[selectedCategory] ?? []).map { ($0, selectedCategory, speed, isBouncing, choosedColor) }

                                    ForEach(patternsToShow.indices, id: \.self) { index in
                                        let patternData = patternsToShow[index]
                                        let patternName = patternData.0
                                        let categoryName = patternData.1
                                        let speedTemp = patternData.2
                                        let isBouncingTemp = patternData.3
                                        let colorTemp = patternData.4

                                        HStack {
                                            
                                            Button(action: {
                                                if favoritePatterns.contains(where: { $0.name == patternName }) {
                                                    removePattern(patternName: patternName)
                                                    favorites[patternName] = false
                                                } else {
                                                    favorites[patternName, default: false].toggle()
                                                    if favorites[patternName] == true {
                                                        savePattern(patternName: patternName, index: index, speed: speedTemp, color: colorTemp)
                                                    } else {
                                                        removePattern(patternName: patternName)
                                                    }
                                                }
                                            }) {
                                                Image(systemName: favorites[patternName, default: false] || favoritePatterns.contains{$0.name == patternName} ? "heart.fill" : "heart")
                                                    .padding()
                                                    .foregroundColor(.white)
                                                    .background(Color.clear)

                                            }

                                            Button(action: {
                                                selectedPattern = patternName
                                                let ver = getVersion(category: categoryName, pattern: patternName)
                                                bluetoothManager.sendPattern(speed: speedTemp, version: ver!, loop: !isBouncingTemp)
                                            }) {
                                                HStack {
                                                    Text(languageManager.localizedString(forKey: patternName))
                                                    Spacer()
                                                }
                                                .padding()
                                                .foregroundColor(.primary)
                                                .background(Color.clear)
                                                .frame(maxWidth: .infinity)
                                            }
                                            .background(selectedPattern == patternName ? Color.green : Color.clear)
                                            .cornerRadius(8)

                                            if selectedCategory == "snake" {
                                                ColorPicker("", selection: $choosedColor)
                                                    .labelsHidden()
                                                    .frame(width: 30, height: 30)
                                                    .padding(.leading, 8)
                                                    .onChange(of: choosedColor, perform: { newColor in
                                                        didColorChange = true
                                                        updatePatternColor(with: newColor)
                                                    })
                                            }

                                            Button(action: {
                                                let ver = getVersion(category: categoryName, pattern: patternName)
                                                currentTask?.cancel()

                                                if selectedCategory == "Favorites" {
                                                    var fav = getFavorite(name: patternName)
                                                    updatePatternColor(with: fav.color)
                                                } else {
                                                    updatePatternColor(with: choosedColor)
                                                }
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
            }
        }
        .onAppear {
                   loadFavoritePatterns()
               }
        .environment(\.locale, .init(identifier: languageManager.selectedLanguage))
    }
}
