//
//  ReleaseTests.swift
//  TetraFireTests
//

import Foundation
import Testing
@testable import TetraFire

struct ReleaseTests {

    // Bundle.main is the host app when tests run inside it.
    private let app = Bundle.main

    @Test func versionIsTwoPointZero() {
        #expect(app.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String == "2.0")
    }

    @Test func privacyManifestDeclaresUserDefaultsReason() throws {
        let url = try #require(app.url(forResource: "PrivacyInfo", withExtension: "xcprivacy"))
        let plist = try #require(
            PropertyListSerialization.propertyList(from: Data(contentsOf: url), format: nil) as? [String: Any]
        )
        #expect(plist["NSPrivacyTracking"] as? Bool == false)
        let apis = try #require(plist["NSPrivacyAccessedAPITypes"] as? [[String: Any]])
        let userDefaults = try #require(
            apis.first { $0["NSPrivacyAccessedAPIType"] as? String == "NSPrivacyAccessedAPICategoryUserDefaults" }
        )
        #expect(userDefaults["NSPrivacyAccessedAPITypeReasons"] as? [String] == ["CA92.1"])
    }

    @Test func deprecatedFullScreenKeyIsGone() {
        #expect(app.object(forInfoDictionaryKey: "UIRequiresFullScreen") == nil)
    }
}
