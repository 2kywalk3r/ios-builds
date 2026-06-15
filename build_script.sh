#!/bin/bash
APP_NAME=$1
BUNDLE_ID=$2

echo "Iniciando script de preparación del proyecto iOS..."
mkdir -p workspace
unzip -q app_source.zip -d workspace/www

# Crear directorios del proyecto
mkdir -p ios_project/src
mkdir -p output

# Escribir AppDelegate.swift
cat << 'EOF' > ios_project/src/AppDelegate.swift
import UIKit
import WebKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        let configuration = WKWebViewConfiguration()
        configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        
        let webView = WKWebView(frame: vc.view.bounds, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let bundleURL = Bundle.main.bundleURL
        let wwwURL = bundleURL.appendingPathComponent("www")
        let indexURL = wwwURL.appendingPathComponent("index.html")
        
        if FileManager.default.fileExists(atPath: indexURL.path) {
            webView.loadFileURL(indexURL, allowingReadAccessTo: wwwURL)
        } else {
            webView.loadHTMLString("<html><body style='display:flex;justify-content:center;align-items:center;height:100vh;flex-direction:column;font-family:-apple-system,BlinkMacSystemFont,sans-serif;background-color:#0f172a;color:#f8fafc;'><h2>Error de Carga</h2><p style='color:#94a3b8;'>No se localizo index.html en los archivos web subidos.</p></body></html>", baseURL: nil)
        }
        
        vc.view.addSubview(webView)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }
}
EOF

# Info.plist
cat << EOF > ios_project/Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIdentifier</key>
    <string>${BUNDLE_ID}</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
    </array>
</dict>
</plist>
EOF

# LaunchScreen.storyboard
cat << 'EOF' > ios_project/LaunchScreen.storyboard
<?xml version="1.0" encoding="UTF-8"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0" toolsVersion="21507" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" launchScreen="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES" initialViewController="01J-lp-oVM">
    <device id="retina6_12" orientation="portrait" appearance="light"/>
    <dependencies>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouch.Plugin" version="21505"/>
        <capability name="Safe area layout guides" minToolsVersion="9.0"/>
        <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
    </dependencies>
    <scenes>
        <scene sceneID="EHf-IW-A2E">
            <objects>
                <viewController id="01J-lp-oVM" sceneMemberID="viewController">
                    <view key="view" contentMode="scaleToFill" id="Ze5-6b-2t3">
                        <rect key="frame" x="0.0" y="0.0" width="393" height="852"/>
                        <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
                        <subviews>
                            <label opaque="NO" userInteractionEnabled="NO" contentMode="left" horizontalHuggingPriority="251" verticalHuggingPriority="251" text="AppCompiler Cloud Build" textAlignment="center" lineBreakMode="tailTruncation" baselineAdjustment="alignBaselines" adjustsFontSizeToFit="YES" translatesAutoresizingMaskIntoConstraints="NO" id="AppTitle">
                                <rect key="frame" x="20" y="411.5" width="353" height="29"/>
                                <fontDescription key="fontDescription" type="system" weight="semibold" pointSize="22"/>
                                <color key="textColor" white="1" alpha="1" colorSpace="custom" customColorSpace="genericGamma22GrayColorSpace"/>
                                <nil key="highlightedColor"/>
                            </label>
                        </subviews>
                        <viewLayoutGuide key="safeArea" id="6Tk-OE-BBY"/>
                        <color key="backgroundColor" red="0.11764705882352941" green="0.22745098039215686" blue="0.54117647058823526" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
                        <constraints>
                            <constraint firstItem="AppTitle" firstAttribute="centerX" secondItem="Ze5-6b-2t3" secondAttribute="centerX" id="C1"/>
                            <constraint firstItem="AppTitle" firstAttribute="centerY" secondItem="Ze5-6b-2t3" secondAttribute="centerY" id="C2"/>
                            <constraint firstItem="AppTitle" firstAttribute="leading" secondItem="6Tk-OE-BBY" secondAttribute="leading" constant="20" id="C3"/>
                        </constraints>
                    </view>
                </viewController>
                <placeholder placeholderIdentifier="IBFirstResponder" id="iYj-Kq-Ea1" userLabel="First Responder" sceneMemberID="firstResponder"/>
            </objects>
            <point key="canvasLocation" x="53" y="375"/>
        </scene>
    </scenes>
</document>
EOF

# Estructura del pbxproj compatible
mkdir -p ios_project/${APP_NAME}.xcodeproj
cat << EOF > ios_project/${APP_NAME}.xcodeproj/project.pbxproj
// !\$*UTF8*\$!
{
	archiveVersion = 1;
	classes = {};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
		B1A1E11122AA333300AAAA01 /* AppDelegate.swift in Sources */ = {isa = PBXBuildFile; fileRef = B1A1E11022AA333300AAAA01 /* AppDelegate.swift */; };
		B1A1E11322AA444400AAAA01 /* www in Resources */ = {isa = PBXBuildFile; fileRef = B1A1E11222AA444400AAAA01 /* www */; };
		B1A1E11522AA555500AAAA01 /* LaunchScreen.storyboard in Resources */ = {isa = PBXBuildFile; fileRef = B1A1E11422AA555500AAAA01 /* LaunchScreen.storyboard */; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
		B1A1E11022AA333300AAAA01 /* AppDelegate.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = src/AppDelegate.swift; sourceTree = "<group>"; };
		B1A1E11222AA444400AAAA01 /* www */ = {isa = PBXFileReference; lastKnownFileType = folder; path = ../workspace/www; sourceTree = "<group>"; };
		B1A1E11422AA555500AAAA01 /* LaunchScreen.storyboard */ = {isa = PBXFileReference; lastKnownFileType = file.storyboard; path = src/LaunchScreen.storyboard; sourceTree = "<group>"; };
		B1A1E11C22AA666600AAAA01 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
		B1A1E11922AA666600AAAA01 /* \${APP_NAME}.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = "\${APP_NAME}.app"; sourceTree = BUILT_PRODUCTS_DIR; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		B1A1E10722AA111100AAAA01 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = ();
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		B1A1E10122AA111100AAAA01 = {
			isa = PBXGroup;
			children = (
				B1A1E10F22AA222200AAAA01 /* CustomGroup */,
				B1A1E11922AA666600AAAA01 /* \${APP_NAME}.app */,
			);
			sourceTree = "<group>";
		};
		B1A1E10F22AA222200AAAA01 /* CustomGroup */ = {
			isa = PBXGroup;
			children = (
				B1A1E11022AA333300AAAA01 /* AppDelegate.swift */,
				B1A1E11222AA444400AAAA01 /* www */,
				B1A1E11422AA555500AAAA01 /* LaunchScreen.storyboard */,
				B1A1E11C22AA666600AAAA01 /* Info.plist */,
			);
			path = .;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		B1A1E10A22AA111100AAAA01 /* \${APP_NAME} */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = B1A1E11E22AA666600AAAA01 /* Build configuration list for PBXNativeTarget "\${APP_NAME}" */;
			buildPhases = (
				B1A1E10522AA111100AAAA01 /* Sources */,
				B1A1E10722AA111100AAAA01 /* Frameworks */,
				B1A1E10822AA111100AAAA01 /* Resources */,
			);
			buildRules = ();
			dependencies = ();
			name = "\${APP_NAME}";
			productName = "\${APP_NAME}";
			productReference = B1A1E11922AA666600AAAA01 /* \${APP_NAME}.app */;
			productType = "com.apple.product-type.application";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		B1A1E10222AA111100AAAA01 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				LastSwiftUpdateCheck = 1400;
				LastUpgradeCheck = 1400;
			};
			buildConfigurationList = B1A1E10322AA111100AAAA01 /* Build configuration list for PBXProject */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = B1A1E10122AA111100AAAA01;
			productRefGroup = B1A1E10122AA111100AAAA01;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				B1A1E10A22AA111100AAAA01 /* \${APP_NAME} */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		B1A1E10822AA111100AAAA01 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				B1A1E11322AA444400AAAA01 /* www in Resources */,
				B1A1E11522AA555500AAAA01 /* LaunchScreen.storyboard in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		B1A1E10522AA111100AAAA01 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				B1A1E11122AA333300AAAA01 /* AppDelegate.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		B1A1E11A22AA666600AAAA01 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CODE_SIGN_STYLE = Manual;
				CODE_SIGNING_ALLOWED = NO;
				CODE_SIGNING_REQUIRED = NO;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				GCC_C_LANGUAGE_STANDARD = gnu11;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"\$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 15.0;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			};
			name = Debug;
		};
		B1A1E11B22AA666600AAAA01 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CODE_SIGN_STYLE = Manual;
				CODE_SIGNING_ALLOWED = NO;
				CODE_SIGNING_REQUIRED = NO;
				COPY_PHASE_STRIP = YES;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_C_LANGUAGE_STANDARD = gnu11;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 15.0;
				MTL_ENABLE_DEBUG_INFO = NO;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				SWIFT_OPTIMIZATION_LEVEL = "-O";
			};
			name = Release;
		};
		B1A1E11F22AA666600AAAA01 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				CODE_SIGN_STYLE = Manual;
				CODE_SIGNING_ALLOWED = NO;
				CODE_SIGNING_REQUIRED = NO;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"\$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = "\${BUNDLE_ID}";
				PRODUCT_NAME = "\$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Debug;
		};
		B1A1E12022AA666600AAAA01 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				CODE_SIGN_STYLE = Manual;
				CODE_SIGNING_ALLOWED = NO;
				CODE_SIGNING_REQUIRED = NO;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"\$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = "\${BUNDLE_ID}";
				PRODUCT_NAME = "\$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		B1A1E10322AA111100AAAA01 /* Build configuration list for PBXProject */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				B1A1E11A22AA666600AAAA01 /* Debug */,
				B1A1E11B22AA666600AAAA01 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		B1A1E11E22AA666600AAAA01 /* Build configuration list for PBXNativeTarget "\${APP_NAME}" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				B1A1E11F22AA666600AAAA01 /* Debug */,
				B1A1E12022AA666600AAAA01 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */
	};
	rootObject = B1A1E10222AA111100AAAA01 /* Project object */;
}
EOF

echo "Ejecutando xcodebuild oficial macos sin firma..."
cd ios_project
xcodebuild -project "\${APP_NAME}.xcodeproj" -scheme "\${APP_NAME}" -configuration Release -sdk iphoneos CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO clean build

echo "Generando Payload IPA..."
cd ..
mkdir -p output/Payload
cp -r ios_project/build/Release-iphoneos/"\${APP_NAME}.app" output/Payload/
cd output
zip -r "\${APP_NAME}.ipa" Payload
echo "¡IPA lista para sideloading!"
