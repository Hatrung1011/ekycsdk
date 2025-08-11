#!/bin/bash

# Script để test pod locally

echo "🧪 Testing pod locally..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf Example/Pods
rm -rf Example/ExampleApp.xcworkspace

# Install pods in example
echo "📦 Installing pods in example..."
cd Example
pod install

if [ $? -eq 0 ]; then
    echo "✅ Pod installation successful!"
    echo "🚀 Opening example project..."
    open ExampleApp.xcworkspace
else
    echo "❌ Pod installation failed!"
    exit 1
fi

echo "🎉 Testing completed! You can now build and run the example app."
