set -eo pipefail

xcodebuild -workspace Example/Retain.xcworkspace \
            -scheme Retain-Example \
            -destination platform=iOS\ Simulator,OS=16.4,name=iPhone\ 14 \
            clean test | xcpretty