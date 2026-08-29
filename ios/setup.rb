# https://github.com/CocoaPods/Xcodeproj
# https://chatgpt.com/s/t_6a92ba4c36988191a6ace598a853ce8b

# Run using: "ruby ios/setup.rb"
# Validate using: "ruby -c ios/setup.rb"

# NOTE: This script is idempotent (That means it can be run multiple times) (Safe for multiple runs)

require "xcodeproj"
require "plist"

puts "🚀 Starting iOS project setup..."

REQUIRED_FILES = ["GoogleService-Info.plist", "PrivacyInfo.xcprivacy"]
PROJECT_PATH = "ios/Runner.xcodeproj"
ENTITLEMENTS_FILE = "Runner.entitlements"
ENTITLEMENTS_PATH = "ios/Runner/#{ENTITLEMENTS_FILE}"

# Loads the project.pbxproj file
project = Xcodeproj::Project.open(PROJECT_PATH)
# NOTE: For standard Flutter projects, we target only the "Runner" app target
target = project.targets.find { |t| t.name == "Runner" }
group = project.main_group.find_subpath("Runner", true)

# Validate project structure
unless target
  puts "❌ Could not find 'Runner' target in project"
  exit 1
end

unless group
  puts "❌ Could not find 'Runner' group in project"
  exit 1
end

# Inject resources: "GoogleService-Info.plist", "PrivacyInfo.xcprivacy"
REQUIRED_FILES.each do |filename|
  file_path = "ios/Runner/#{filename}"

  # Validate that "GoogleService-Info.plist" & "PrivacyInfo.xcprivacy" files exist
  # Validate required files before injection
  unless File.exist?(file_path)
    puts "❌ Missing required file: #{filename}, Please ensure it is placed in ios/Runner/."
    exit 1
  end

  # Validate plist files
  def validate_plist(file_path)
    Plist.parse_xml(file_path)
    true
  rescue
    false
  end

  unless validate_plist(file_path)
    puts "❌ Invalid plist format: #{file_path}"
    exit 1
  end

  # Check if file already exists in project (idempotent)
  existing_ref = group.files.find do |file|
    file.path == filename || file.path.to_s.end_with?(filename)
  end

  if existing_ref
    puts "✅ #{filename} already exists in project"
  else
    # Adds file references (replaces drag-and-drop)
    file_ref = group.new_file(file_path)
    target.resources_build_phase.add_file_reference(file_ref)
    puts "✅ Added #{filename} to project"
  end
end

aps_environment = ENV["APS_ENVIRONMENT"] || "development"
unless File.exist?(ENTITLEMENTS_PATH)
  File.write(ENTITLEMENTS_PATH, <<~ENTITLEMENTS)
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <!-- Only security-sensitive capabilities like: -->
      <!-- aps-environment (Push Notifications) -->
      <!-- com.apple.security.application-groups (App Groups) -->
      <!-- com.apple.developer.healthkit (HealthKit) -->
      <!-- com.apple.developer.networking.vpn.api (VPN) -->
      <!-- com.apple.developer.in-app-payments (Apple Pay) -->
    
      <!-- Entitlements are embedded in the code signature and validated by Apple and the OS for security-->
    
      <key>aps-environment</key>
      <string>#{aps_environment}</string>
    
      <!-- Other Entitlements if applicable... -->
    </dict>
    </plist>
  ENTITLEMENTS
  group.new_file(ENTITLEMENTS_PATH)
  puts "✅ Created #{ENTITLEMENTS_PATH}"
end

# Configure entitlements (only if not set)
# NOTE: This does't toggle the capability UI in Xcode, but sets the entitlement path
target.build_configurations.each do |config|
  # Only set to Manual if not already configured
  # Only sets it if it's nil or not present
  unless config.build_settings["CODE_SIGN_STYLE"]
    config.build_settings["CODE_SIGN_STYLE"] = "Manual" # Manual | Automatic
    puts "✅ Set CODE_SIGN_STYLE to Manual"
  end

  if config.build_settings["CODE_SIGN_ENTITLEMENTS"].nil?
    config.build_settings["CODE_SIGN_ENTITLEMENTS"] = "Runner/#{ENTITLEMENTS_FILE}"
    puts "✅ Set CODE_SIGN_ENTITLEMENTS"
  end
end

# Capabilities
attributes = project.root_object.attributes["TargetAttributes"] ||= {}
target_attrs = attributes[target.uuid] ||= {}
target_attrs["SystemCapabilities"] ||= {}

# Enable push notifications capability
# Add system capability (Push notification)
CAPABILITIES = [
  "com.apple.Push", # Push notifications
  "com.apple.BackgroundModes", # Background fetch, remote notifications
  # "com.apple.SignInWithApple", # Sign in with Apple
  # "com.apple.Location", # Location Services
  # "com.apple.HealthKit", # Access HealthKit data
  # "com.apple.HomeKit", # Home automation
  # "com.apple.NearFieldCommunication", # NFC tag reading
  # "com.apple.Wallet", # Apple Wallet / PassKit
  # "com.apple.GameCenter", # Game Center integration
  # "com.apple.Siri", # SiriKit usage
  # "com.apple.Music", # Apple Music usage
  # "com.apple.Handoff", # Continuity and Handoff
  # "com.apple.CloudKit", # iCloud and CloudKit
  # "com.apple.CarPlay", # CarPlay Support
  # "com.apple.VPN",  # VPN configuration
  # "com.apple.CoreML" # Machine learning models
]
CAPABILITIES.each do |capability|
  if target_attrs["SystemCapabilities"][capability].nil?
    # Enables capability (replaces manual setting in Signing & Capabilities tab)
    target_attrs["SystemCapabilities"][capability] = {"enabled" => 1}
    puts "✅ Enabled \"#{capability}\" capability"
  end
end

# Writes those changes back to disk "project.pbxproj"
enabled_caps = CAPABILITIES.select { |capability| target_attrs["SystemCapabilities"][capability]&.[]("enabled") == 1 }

project.save

puts "\n Setup Summary:"
puts "\t• Files added/verified: #{REQUIRED_FILES.join(", ")}"
puts "\t• Entitlements configured: #{ENTITLEMENTS_PATH}"
puts "\t• Enabled capabilities: #{enabled_caps.join(", ")}"
puts "✅ iOS project setup completed successfully"
