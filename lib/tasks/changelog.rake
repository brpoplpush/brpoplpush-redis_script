# frozen_string_literal: true

desc "Generate a Changelog"
task :changelog do
  # rubocop:disable Style/MutableConstant
  CHANGELOG_CMD ||= %w[
    github_changelog_generator
    -u
    brpoplpush
    -p
    brpoplpush-redis_script
    --no-verbose
    --token
  ]
  ADD_CHANGELOG_CMD      ||= "git add --all"
  COMMIT_CHANGELOG_CMD   ||= "git commit -a -m 'Update changelog'"
  # rubocop:enable Style/MutableConstant

  sh("git checkout master")
  sh(*CHANGELOG_CMD.push(ENV["CHANGELOG_GITHUB_TOKEN"]))
  sh(ADD_CHANGELOG_CMD)
  sh(COMMIT_CHANGELOG_CMD)
end
