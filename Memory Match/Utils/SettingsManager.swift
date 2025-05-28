import Foundation

class SettingsManager {
    static let shared = SettingsManager()

    var isSoundOn: Bool {
        get { UserDefaults.standard.bool(forKey: "sound") }
        set { UserDefaults.standard.set(newValue, forKey: "sound") }
    }

    var isVibrationOn: Bool {
        get { UserDefaults.standard.bool(forKey: "vibration") }
        set { UserDefaults.standard.set(newValue, forKey: "vibration") }
    }

    private init() {

        if UserDefaults.standard.object(forKey: "sound") == nil {
            isSoundOn = true
        }
        if UserDefaults.standard.object(forKey: "vibration") == nil {
            isVibrationOn = true
        }
    }
}
