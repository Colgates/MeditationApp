//
//  Colors.swift
//  MeditationApp
//
//  Created by Evgenii Kolgin on 30.08.2021.
//

import UIKit

struct Colors {
    
    static let tintColor = UIColor.darkGray
    static let selectedTintColor = UIColor.systemBlue
    
    static let defaultMainColor = UIColor(red: 0.925, green: 0.941, blue: 0.953, alpha: 1.0)
    static let defaultSecondaryColor = UIColor(red: 0.482, green: 0.502, blue: 0.549, alpha: 1.0)
    static let defaultLightShadowSolidColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.0)
    static let defaultDarkShadowSolidColor = UIColor(red: 0.820, green: 0.851, blue: 0.902, alpha: 1.0)
    
    static let darkThemeMainColor = UIColor(red: 0.188, green: 0.192, blue: 0.208, alpha: 1.0)
    static let darkThemeSecondaryColor = UIColor(red: 0.910, green: 0.910, blue: 0.910, alpha: 1.0)
    static let darkThemeLightShadowSolidColor = UIColor(red: 0.243, green: 0.247, blue: 0.275, alpha: 1.0)
    static let darkThemeDarkShadowSolidColor = UIColor(red: 0.137, green: 0.137, blue: 0.137, alpha: 1.0)
    
    public static var main: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.darkThemeMainColor
            } else {
                return Colors.defaultMainColor
            }
        }
    }()
    
    public static var secondaryColor: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.darkThemeSecondaryColor
            } else {
                return Colors.defaultSecondaryColor
            }
        }
    }()
    
    public static var lightShadow: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.darkThemeLightShadowSolidColor
            } else {
                return Colors.defaultLightShadowSolidColor
            }
        }
    }()
    
    public static var darkShadow: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return Colors.darkThemeDarkShadowSolidColor
            } else {
                return Colors.defaultDarkShadowSolidColor
            }
        }
    }()
}


