# https://github.com/CocoaPods/Xcodeproj
# https://chatgpt.com/s/t_6a92ba4c36988191a6ace598a853ce8b

# Run using: "ruby ios/setup.rb"
# Validate using: "ruby -c ios/setup.rb"

# NOTE: This script is idempotent.
# It can be run multiple times.

require "xcodeproj"
require "plist"

puts "🚀 Starting iOS project setup..."

# Paths

PROJECT_PATH = "ios/Runner.xcodeproj"

RUNNER_DIRECTORY="ios/Runner"

ENTITLEMENTS_FILE = "Runner.entitlements"
ENTITLEMENTS_PATH = File.join(RUNNER_DIRECTORY, ENTITLEMENTS_FILE)

REQUIRED_FILES = ["GoogleService-Info.plist", "PrivacyInfo.xcprivacy"]

# Loads Xcode project

project = Xcodeproj::Project.open(PROJECT_PATH)

# NOTE: For standard Flutter projects, we target only the "Runner" app target
target = project.targets.find { |t| t.name == "Runner" }

# Standard Flutter Runner group
group = project.main_group.find_subpath("Runner", true)

# Validate project structure

unless target
  puts "❌ Could not find 'Runner' target in #{PROJECT_PATH}"
  exit 1
end

unless group
  puts "❌ Could not find 'Runner' group in #{PROJECT_PATH}"
  exit 1
end


puts "✅ Found Runner target"
puts "✅ Found Runner group"

# Helpers

# Validate plist files
def validate_plist(file_path)
  Plist.parse_xml(file_path)
  true
rescue StandardError
  false
end

# Find an existing file reference by filename.
def find_file_reference(group, filename)
  group.files.find do |file|
    file.path.to_s == filename
  end
end

# Check whether a file reference is already present in the resource phase.
def resource_in_build_phase?(target, file_ref)
  target.resources_build_phase.files.any? do |build_file|
    build_file.file_ref == file_ref
  end
end


# Inject resources: "GoogleService-Info.plist", "PrivacyInfo.xcprivacy"
REQUIRED_FILES.each do |filename|
  filesystem_path = File.join(RUNNER_DIRECTORY, filename)

  # Validate that "GoogleService-Info.plist" & "PrivacyInfo.xcprivacy" files exist
  # Validate required files before injection
  unless File.exist?(filesystem_path)
    puts "❌ Missing required file:"
    puts "   #{filesystem_path}"
    puts "   Please ensure it exists in ios/Runner/"
    exit 1
  end

  unless validate_plist(filesystem_path)
    puts "❌ Invalid plist format:"
    puts "   #{filesystem_path}"
    exit 1
  end

  # Find existing Xcode file reference

  file_ref = find_file_reference(group, filename)

  if file_ref
    puts "✅ #{filename} file reference already exists"
  else
    # Adds file references (replaces drag-and-drop)
    # IMPORTANT
    # This path is relative to the Runner group
    file_ref = group.new_file(filename)
    puts "✅ Added #{filename} file reference"
  end


  # Add to copy bundle resources if necessary
  unless resource_in_build_phase?(target, file_ref)
    target.resources_build_phase.add_file_reference(file_ref)

    puts "✅ Added #{filename} to copy bundle resources"
  else
    puts "✅ #{filename} already exists in copy bundle resources"
  end
end

# Entitlements

aps_environment = ENV.fetch("APS_ENVIRONMENT", "development")

unless File.exist?(ENTITLEMENTS_PATH)
  File.write(
    ENTITLEMENTS_PATH, 
    <<~ENTITLEMENTS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <!-- 
          Only security-sensitive capabilities can be declared here:
        
          Examples:
            aps-environment (Push Notifications)
            com.apple.security.application-groups (App Groups)
            com.apple.developer.networking.vpn.api (VPN)
            com.apple.developer.in-app-payments (Apple Pay)
        -->
      
        <!-- Entitlements are embedded in the code signature and validated by Apple and the OS for security-->
      
        <key>aps-environment</key>
        <string>#{aps_environment}</string>
      
        <!-- Other Entitlements if applicable... -->
      </dict>
      </plist>
    ENTITLEMENTS
  )
  puts "✅ Created #{ENTITLEMENTS_PATH}"
else
  puts "✅ #{ENTITLEMENTS_PATH} already exists"
end

# Add entitlements file to Xcode project
entitlements_ref = find_file_reference(group, ENTITLEMENTS_FILE)
unless entitlements_ref
  # IMPORTANT:
  # Relative to the Runner group
  entitlements_ref = group.new_file(ENTITLEMENTS_FILE)

  puts "✅ Added #{ENTITLEMENTS_FILE} file reference"
else
  puts "✅ #{ENTITLEMENTS_FILE} file reference already exists"
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

  expected = "Runner/Runner.entitlements"
  if config.build_settings["CODE_SIGN_ENTITLEMENTS"] != expected
    config.build_settings["CODE_SIGN_ENTITLEMENTS"] = expected
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
  "com.apple.BackgroundModes" # Background fetch, remote notifications
  # "com.apple.SignInWithApple", # Sign in with Apple
  # "com.apple.Location", # Location Services
  # "com.apple.NearFieldCommunication", # NFC tag reading
  # "com.apple.Wallet", # Apple Wallet / PassKit
  # "com.apple.Siri", # SiriKit usage
  # "com.apple.Handoff", # Continuity and Handoff
  # "com.apple.CloudKit", # iCloud and CloudKit
  # "com.apple.VPN",  # VPN configuration
  # "com.apple.CoreML" # Machine learning models
]

CAPABILITIES.each do |capability|
  if target_attrs["SystemCapabilities"][capability].nil?
    # Enables capability (replaces manual setting in Signing & Capabilities tab)
    target_attrs["SystemCapabilities"][capability] = {"enabled" => 1}
    puts "✅ Enabled \"#{capability}\" capability"
  else
    puts "✅ \"#{capability}\" capability already configured"
  end
end

project.save

# Summary

# Writes those changes back to disk "project.pbxproj"
enabled_caps = CAPABILITIES.select { |capability| target_attrs["SystemCapabilities"][capability]&.[]("enabled") == 1 }

puts "\n Setup Summary:"
puts "\t• Files added/verified: #{REQUIRED_FILES.join(", ")}"
puts "\t• Entitlements configured: #{ENTITLEMENTS_PATH}"
puts "\t• Enabled capabilities: #{enabled_caps.join(", ")}"
puts "✅ iOS project setup completed successfully"
