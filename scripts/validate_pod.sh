#!/bin/bash

# Script để validate và publish pod nlekycsdk

echo "🔍 Validating podspec..."
pod spec lint nlekycsdk.podspec --allow-warnings

if [ $? -eq 0 ]; then
    echo "✅ Podspec validation successful!"
    
    echo "📦 Publishing to CocoaPods..."
    pod trunk push nlekycsdk.podspec --allow-warnings
    
    if [ $? -eq 0 ]; then
        echo "🎉 Successfully published to CocoaPods!"
    else
        echo "❌ Failed to publish to CocoaPods"
        exit 1
    fi
else
    echo "❌ Podspec validation failed!"
    exit 1
fi
