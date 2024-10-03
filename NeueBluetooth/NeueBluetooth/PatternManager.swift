//
//  PatternManager.swift
//  NeueBluetooth
//
//

import Foundation

/* Alle Muster-Arrays hier definieren */
class PatternManager: NSObject, ObservableObject {
    
    @Published var threeSnakePattern: [(

        ledIndex1: UInt8, led1R: UInt8, led1G: UInt8, led1B: UInt8,

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

        duration: TimeInterval

    )] = [

        // Zeitschritt 1

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 255, 0, 0,

         0.5),

        // Zeitschritt 2

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 255, 0, 0,

         20, 255, 0, 0,

         0.5),

        // Zeitschritt 3

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 255, 0, 0,

         19, 255, 0, 0,

         20, 255, 0, 0,

         0.5),

        // Zeitschritt 4

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 255, 0, 0,

         18, 255, 0, 0,

         19, 255, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 5

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 255, 0, 0,

         17, 255, 0, 0,

         18, 255, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 6

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 255, 0, 0,

         16, 255, 0, 0,

         17, 255, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 7

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 255, 0, 0,

         15, 255, 0, 0,

         16, 255, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 8

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 255, 0, 0,

         14, 255, 0, 0,

         15, 255, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 9

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 255, 0, 0,

         13, 255, 0, 0,

         14, 255, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 10

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 255, 0, 0,

         12, 255, 0, 0,

         13, 255, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 11

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 255, 0, 0,

         11, 255, 0, 0,

         12, 255, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 12

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 255, 0, 0,

         10, 255, 0, 0,

         11, 255, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 13

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 255, 0, 0,

         9, 255, 0, 0,

         10, 255, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 14

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 255, 0, 0,

         8, 255, 0, 0,

         9, 255, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 15

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 255, 0, 0,

         7, 255, 0, 0,

         8, 255, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 16

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 255, 0, 0,

         6, 255, 0, 0,

         7, 255, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 17

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 255, 0, 0,

         5, 255, 0, 0,

         6, 255, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 18

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 255, 0, 0,

         4, 255, 0, 0,

         5, 255, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 19

        (1, 0, 0, 0,

         2, 255, 0, 0,

         3, 255, 0, 0,

         4, 255, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 20

        (1, 255, 0, 0,

         2, 255, 0, 0,

         3, 255, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 21

        (1, 255, 0, 0,

         2, 255, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 22

        (1, 255, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        ]


    // Random-Colors 1

    @Published var randomPattern: [(

        ledIndex1: UInt8, led1R: UInt8, led1G: UInt8, led1B: UInt8,

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

        duration: TimeInterval

    )] = [

        // Zeitschritt 1

        (1, 255, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 255, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 255, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 255, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 255, 0, 0,

         0.5),

        // Zeitschritt 2

        (1, 0, 0, 0,

         2, 0, 255, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 255, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 255, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 255, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 3

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 255,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 255,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 255,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 255,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 4

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 255, 255, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 255, 255, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 255, 255, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 255, 255, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 5

        (1, 255, 0, 255,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 255, 0, 255,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 255, 0, 255,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 255, 0, 255,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 255, 0, 255,

         0.5),

        // Zeitschritt 6

        (1, 0, 0, 0,

         2, 0, 255, 255,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 255, 255,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 255, 255,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 255, 255,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 7

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 125, 255, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 125, 255, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 125, 255, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 125, 255, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 8

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 125, 0, 255,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 125, 0, 255,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 125, 0, 255,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 125, 0, 255,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 9

        (1, 0, 85, 180,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 85, 180,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 85, 180,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 85, 180,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 85, 180,

         0.5),

        // Zeitschritt 10

        (1, 0, 0, 0,

         2, 85, 155, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 85, 155, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 85, 155, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 85, 155, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

    ]



    // Fade Muster 1

    @Published var fadePattern: [(

        ledIndex1: UInt8, led1R: UInt8, led1G: UInt8, led1B: UInt8,

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

        duration: TimeInterval

    )] = [

        // Zeitschritt 1

        (1, 255, 0, 0,

         2, 255, 0, 0,

         3, 255, 0, 0,

         4, 255, 0, 0,

         5, 255, 0, 0,

         6, 255, 0, 0,

         7, 255, 0, 0,

         8, 255, 0, 0,

         9, 255, 0, 0,

         10, 255, 0, 0,

         11, 255, 0, 0,

         12, 255, 0, 0,

         13, 255, 0, 0,

         14, 255, 0, 0,

         15, 255, 0, 0,

         16, 255, 0, 0,

         17, 255, 0, 0,

         18, 255, 0, 0,

         19, 255, 0, 0,

         20, 255, 0, 0,

         1.5),

        // Zeitschritt 2

        (1, 255, 85, 0,

         2, 255, 85, 0,

         3, 255, 85, 0,

         4, 255, 85, 0,

         5, 255, 85, 0,

         6, 255, 85, 0,

         7, 255, 85, 0,

         8, 255, 85, 0,

         9, 255, 85, 0,

         10, 255, 85, 0,

         11, 255, 85, 0,

         12, 255, 85, 0,

         13, 255, 85, 0,

         14, 255, 85, 0,

         15, 255, 85, 0,

         16, 255, 85, 0,

         17, 255, 85, 0,

         18, 255, 85, 0,

         19, 255, 85, 0,

         20, 255, 85, 0,

         1.5),

        // Zeitschritt 3

        (1, 255, 170, 0,

         2, 255, 170, 0,

         3, 255, 170, 0,

         4, 255, 170, 0,

         5, 255, 170, 0,

         6, 255, 170, 0,

         7, 255, 170, 0,

         8, 255, 170, 0,

         9, 255, 170, 0,

         10, 255, 170, 0,

         11, 255, 170, 0,

         12, 255, 170, 0,

         13, 255, 170, 0,

         14, 255, 170, 0,

         15, 255, 170, 0,

         16, 255, 170, 0,

         17, 255, 170, 0,

         18, 255, 170, 0,

         19, 255, 170, 0,

         20, 255, 170, 0,

         1.5),

        // Zeitschritt 4

        (1, 255, 255, 0,

         2, 255, 255, 0,

         3, 255, 255, 0,

         4, 255, 255, 0,

         5, 255, 255, 0,

         6, 255, 255, 0,

         7, 255, 255, 0,

         8, 255, 255, 0,

         9, 255, 255, 0,

         10, 255, 255, 0,

         11, 255, 255, 0,

         12, 255, 255, 0,

         13, 255, 255, 0,

         14, 255, 255, 0,

         15, 255, 255, 0,

         16, 255, 255, 0,

         17, 255, 255, 0,

         18, 255, 255, 0,

         19, 255, 255, 0,

         20, 255, 255, 0,

         1.5),

        // Zeitschritt 5

        (1, 170, 255, 0,

         2, 170, 255, 0,

         3, 170, 255, 0,

         4, 170, 255, 0,

         5, 170, 255, 0,

         6, 170, 255, 0,

         7, 170, 255, 0,

         8, 170, 255, 0,

         9, 170, 255, 0,

         10, 170, 255, 0,

         11, 170, 255, 0,

         12, 170, 255, 0,

         13, 170, 255, 0,

         14, 170, 255, 0,

         15, 170, 255, 0,

         16, 170, 255, 0,

         17, 170, 255, 0,

         18, 170, 255, 0,

         19, 170, 255, 0,

         20, 170, 255, 0,

         1.5),

        // Zeitschritt 6

        (1, 85, 255, 0,

         2, 85, 255, 0,

         3, 85, 255, 0,

         4, 85, 255, 0,

         5, 85, 255, 0,

         6, 85, 255, 0,

         7, 85, 255, 0,

         8, 85, 255, 0,

         9, 85, 255, 0,

         10, 85, 255, 0,

         11, 85, 255, 0,

         12, 85, 255, 0,

         13, 85, 255, 0,

         14, 85, 255, 0,

         15, 85, 255, 0,

         16, 85, 255, 0,

         17, 85, 255, 0,

         18, 85, 255, 0,

         19, 85, 255, 0,

         20, 85, 255, 0,

         1.5),

        // Zeitschritt 7

        (1, 0, 255, 0,

         2, 0, 255, 0,

         3, 0, 255, 0,

         4, 0, 255, 0,

         5, 0, 255, 0,

         6, 0, 255, 0,

         7, 0, 255, 0,

         8, 0, 255, 0,

         9, 0, 255, 0,

         10, 0, 255, 0,

         11, 0, 255, 0,

         12, 0, 255, 0,

         13, 0, 255, 0,

         14, 0, 255, 0,

         15, 0, 255, 0,

         16, 0, 255, 0,

         17, 0, 255, 0,

         18, 0, 255, 0,

         19, 0, 255, 0,

         20, 0, 255, 0,

         1.5),

        // Zeitschritt 8

        (1, 0, 255, 85,

         2, 0, 255, 85,

         3, 0, 255, 85,

         4, 0, 255, 85,

         5, 0, 255, 85,

         6, 0, 255, 85,

         7, 0, 255, 85,

         8, 0, 255, 85,

         9, 0, 255, 85,

         10, 0, 255, 85,

         11, 0, 255, 85,

         12, 0, 255, 85,

         13, 0, 255, 85,

         14, 0, 255, 85,

         15, 0, 255, 85,

         16, 0, 255, 85,

         17, 0, 255, 85,

         18, 0, 255, 85,

         19, 0, 255, 85,

         20, 0, 255, 85,

         1.5),

        // Zeitschritt 9

        (1, 0, 255, 170,

         2, 0, 255, 170,

         3, 0, 255, 170,

         4, 0, 255, 170,

         5, 0, 255, 170,

         6, 0, 255, 170,

         7, 0, 255, 170,

         8, 0, 255, 170,

         9, 0, 255, 170,

         10, 0, 255, 170,

         11, 0, 255, 170,

         12, 0, 255, 170,

         13, 0, 255, 170,

         14, 0, 255, 170,

         15, 0, 255, 170,

         16, 0, 255, 170,

         17, 0, 255, 170,

         18, 0, 255, 170,

         19, 0, 255, 170,

         20, 0, 255, 170,

         1.5),

         // Zeitschritt 10

        (1, 0, 255, 255,

         2, 0, 255, 255,

         3, 0, 255, 255,

         4, 0, 255, 255,

         5, 0, 255, 255,

         6, 0, 255, 255,

         7, 0, 255, 255,

         8, 0, 255, 255,

         9, 0, 255, 255,

         10, 0, 255, 255,

         11, 0, 255, 255,

         12, 0, 255, 255,

         13, 0, 255, 255,

         14, 0, 255, 255,

         15, 0, 255, 255,

         16, 0, 255, 255,

         17, 0, 255, 255,

         18, 0, 255, 255,

         19, 0, 255, 255,

         20, 0, 255, 255,

         1.5),

        // Zeitschritt 11

       (1, 0, 170, 255,

        2, 0, 170, 255,

        3, 0, 170, 255,

        4, 0, 170, 255,

        5, 0, 170, 255,

        6, 0, 170, 255,

        7, 0, 170, 255,

        8, 0, 170, 255,

        9, 0, 170, 255,

        10, 0, 170, 255,

        11, 0, 170, 255,

        12, 0, 170, 255,

        13, 0, 170, 255,

        14, 0, 170, 255,

        15, 0, 170, 255,

        16, 0, 170, 255,

        17, 0, 170, 255,

        18, 0, 170, 255,

        19, 0, 170, 255,

        20, 0, 170, 255,

        1.5),

        // Zeitschritt 12

       (1, 0, 85, 255,

        2, 0, 85, 255,

        3, 0, 85, 255,

        4, 0, 85, 255,

        5, 0, 85, 255,

        6, 0, 85, 255,

        7, 0, 85, 255,

        8, 0, 85, 255,

        9, 0, 85, 255,

        10, 0, 85, 255,

        11, 0, 85, 255,

        12, 0, 85, 255,

        13, 0, 85, 255,

        14, 0, 85, 255,

        15, 0, 85, 255,

        16, 0, 85, 255,

        17, 0, 85, 255,

        18, 0, 85, 255,

        19, 0, 85, 255,

        20, 0, 85, 255,

        1.5),

        // Zeitschritt 13

       (1, 0, 0, 255,

        2, 0, 0, 255,

        3, 0, 0, 255,

        4, 0, 0, 255,

        5, 0, 0, 255,

        6, 0, 0, 255,

        7, 0, 0, 255,

        8, 0, 0, 255,

        9, 0, 0, 255,

        10, 0, 0, 255,

        11, 0, 0, 255,

        12, 0, 0, 255,

        13, 0, 0, 255,

        14, 0, 0, 255,

        15, 0, 0, 255,

        16, 0, 0, 255,

        17, 0, 0, 255,

        18, 0, 0, 255,

        19, 0, 0, 255,

        20, 0, 0, 255,

        1.5),

        ]



    // Regen Muster

    @Published var rainPattern: [(

        ledIndex1: UInt8, led1R: UInt8, led1G: UInt8, led1B: UInt8,

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

        duration: TimeInterval

    )] = [

        // Zeitschritt 1

        (1, 255, 255, 255,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 255, 255, 255,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 255, 255, 255,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 255, 255, 255,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 255, 255, 255,

         19, 0, 0, 0,

         20, 0, 0, 0,

         0.5),

        // Zeitschritt 2

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 255, 255, 255,

         4, 255, 255, 255,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 255, 255, 255,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 255, 255, 255,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 255, 255, 255,

         18, 0, 0, 0,

         19, 255, 255, 255,

         20, 0, 0, 0,

         0.75),

        // Zeitschritt 3

        (1, 0, 0, 0,

         2, 255, 255, 255,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 255, 255, 255,

         6, 0, 0, 0,

         7, 255, 255, 255,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 255, 255, 255,

         15, 255, 255, 255,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 255, 255, 255,

         0.35),

        // Zeitschritt 4

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 255, 255, 255,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 255, 255, 255,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 255, 255, 255,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 255, 255, 255,

         18, 255, 255, 255,

         19, 0, 0, 0,

         20, 0, 0, 0,

         1.0),

        // Zeitschritt 5

        (1, 0, 0, 0,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 255, 255, 255,

         6, 0, 0, 0,

         7, 255, 255, 255,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 255, 255, 255,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 255, 255, 255,

         15, 0, 0, 0,

         16, 255, 255, 255,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 255, 255, 255,

         0.5),

        // Zeitschritt 6

        (1, 255, 255, 255,

         2, 0, 0, 0,

         3, 255, 255, 255,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 255, 255, 255,

         7, 0, 0, 0,

         8, 0, 0, 0,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 255, 255, 255,

         12, 0, 0, 0,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 255, 255, 255,

         16, 0, 0, 0,

         17, 0, 0, 0,

         18, 255, 255, 255,

         19, 0, 0, 0,

         20, 0, 0, 0,

         1.0),

        // Zeitschritt 7

        (1, 0, 0, 0,

         2, 255, 255, 255,

         3, 0, 0, 0,

         4, 0, 0, 0,

         5, 0, 0, 0,

         6, 0, 0, 0,

         7, 0, 0, 0,

         8, 255, 255, 255,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 0, 0, 0,

         13, 255, 255, 255,

         14, 255, 255, 255,

         15, 0, 0, 0,

         16, 0, 0, 0,

         17, 255, 255, 255,

         18, 0, 0, 0,

         19, 0, 0, 0,

         20, 0, 0, 0,

         1.0),

        // Zeitschritt 8

        (1, 255, 255, 255,

         2, 0, 0, 0,

         3, 0, 0, 0,

         4, 255, 255, 255,

         5, 0, 0, 0,

         6, 255, 255, 255,

         7, 0, 0, 0,

         8, 255, 255, 255,

         9, 0, 0, 0,

         10, 0, 0, 0,

         11, 0, 0, 0,

         12, 255, 255, 255,

         13, 0, 0, 0,

         14, 0, 0, 0,

         15, 255, 255, 255,

         16, 255, 255, 255,

         17, 0, 0, 0,

         18, 0, 0, 0,

         19, 255, 255, 255,

         20, 0, 0, 0,

         0.5),

        ]
}
