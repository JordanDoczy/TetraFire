//
//  Assets.swift
//  TetraFire
//
//  Created by Jordan Doczy on 1/25/16.
//  Copyright © 2016 Jordan Doczy. All rights reserved.
//

import UIKit

struct Assets {
    struct Effects {
        static let dust      = "DustEffect.sks"
        static let explosion = "ExplosionEffect.sks"
        static let fire      = "FireEffect.sks"
        static let rain      = "RainEffect.sks"
        static let smoke     = "SmokeEffect.sks"
    }
    
    struct Images {
        struct Background {
            static let clouds   = "clouds"
            static let earth    = "earth"
            static let fire     = "fire"
            static let galaxy   = "galaxy"
            static let mars     = "mars"
            static let milkyWay = "milkyway"
            static let pluto    = "pluto"
            static let space    = "space"
            static let sun      = "sun"
            static let venus    = "venus"
        }
        
        static let gradient     = "gradient"
    }
    
    struct Sounds {
        static let bgm       = ["bgm5.mp3", "bgm7.wav", "bgm6.wav", "bgm2.wav", "bgm3.wav", "bgm4.wav", "bgm1.wav"]
        static let click     = "click.wav"
        static let ding      = "ding.wav"
        static let dowseFire = "dowseFire.wav"
        static let fourLine  = "4-line.wav"
        static let line      = "line.wav"
        static let pop       = "pop.wav"
        static let thud      = "thud.wav"
    }
}
