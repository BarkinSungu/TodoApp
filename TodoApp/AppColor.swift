import SwiftUI

public enum AppColors {
    // Text
    public static let primaryText = Color.black
    public static let secondaryText = Color.black.opacity(0.5)

    // Backgrounds
    // Butter Yellow palette
    public static let butterYellow = Color(red: 1.0, green: 0.93, blue: 0.6) // #FFE E99 ~ Butter
    public static let butterYellowLight = Color(red: 1.0, green: 0.96, blue: 0.75) // lighter for New Task screen
    public static let butterYellowDark = Color(red: 0.98, green: 0.88, blue: 0.5) // darker for list rows
    
    //button colors
    public static let butterRed = Color(red: 0.95, green: 0.45, blue: 0.45)
    public static let butterGreen = Color(red: 0.32, green: 0.6, blue: 0.36)

    // Generic surfaces
    public static let surface = Color.white.opacity(0.0) // placeholder if needed

    // Semantic Colors
    public static let todayScreenBackground = Color(red: 1.0, green: 0.96, blue: 0.75)
    public static let listRowBackground = Color(red: 0.98, green: 0.88, blue: 0.5)
    public static let generalText = Color.black

    // UIColor for UIKit usage
#if canImport(UIKit)
    public static let uiTodayScreenBackground = UIColor(red: 1.0, green: 0.96, blue: 0.75, alpha: 1.0)
    public static let uiListRowBackground = UIColor(red: 0.98, green: 0.88, blue: 0.5, alpha: 1.0)
    public static let uiGeneralText = UIColor.black
#endif

    // NSColor for AppKit usage
#if canImport(AppKit)
    public static let nsTodayScreenBackground = NSColor(red: 1.0, green: 0.96, blue: 0.75, alpha: 1.0)
    public static let nsListRowBackground = NSColor(red: 0.98, green: 0.88, blue: 0.5, alpha: 1.0)
    public static let nsGeneralText = NSColor.black
#endif
}
