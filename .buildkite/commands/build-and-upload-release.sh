#! /bin/bash -eu

echo "--- :rubygems: Setting up Gems"
install_gems

echo "--- :hammer_and_wrench: Build and Test"
bundle exec fastlane build_and_upload_app_store create_github_release:true
