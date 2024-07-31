# frozen_string_literal: true

platform :mac do
  lane :build_and_upload_app_store do |options|
    # configure_apply
    # sh('rake dependencies:pod:clean')
    # cocoapods

    # setup_ci

    # app_store_code_signing

    archive_path = File.join(BUILD_FOLDER, 'Simplenote-Mac.xcarchive')
    build_simplenote(
      codesign: true,
      archive_path: archive_path
    )

    # sentry_upload_dsym(
    #   auth_token: get_required_env('SENTRY_AUTH_TOKEN'),
    #   org_slug: 'a8c',
    #   project_slug: 'simplenotemacos',
    #   # At the time of writing, there's no way to explicitly configure the
    #   # dSYM path, but build_mac_app sets it in the environment if successful.
    #   # See `bundle exec fastlane action build_mac_app`.
    #   dsym_path: ENV.fetch('DSYM_OUTPUT_PATH', nil)
    # )

    # # Do not create the GitHub release unless explicitly requested
    # if options[:create_github_release]
    #   archive_zip_path = "#{archive_path}.zip"
    #   zip(path: archive_path, output_path: archive_zip_path)

    #   create_release(
    #     repository: GITHUB_REPO,
    #     version: ios_get_app_version(public_version_xcconfig_file: VERSION_FILE_PATH),
    #     release_notes_file_path: 'Simplenote/Resources/release_notes.txt',
    #     release_assets: [archive_zip_path],
    #     prerelease: options[:prerelease]
    #   )
    # end

    UI.message('Generating pkg via productbuild because gym does not do it for us...')
    pkg_path = File.join(BUILD_FOLDER, 'Simplenote.pkg')
    sh("productbuild --component '#{File.join(BUILD_FOLDER, 'Simplenote.app')}' '#{pkg_path}'")

    upload_to_testflight(
      pkg: pkg_path,
      api_key: app_store_connect_api_key
    )
  end
end
