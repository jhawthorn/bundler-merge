require "minitest/autorun"

class TestBundlerMerge < Minitest::Test
  FIXTURES = File.expand_path("fixtures", __dir__)
  BIN = File.expand_path("../bin/bundler-merge", __dir__)

  def test_example_test
    result = run_merge(
      "rack_and_rack_test/Gemfile.lock.rack",
      "rack_and_rack_test/Gemfile.lock.orig",
      "rack_and_rack_test/Gemfile.lock.rack-test",
    )

    assert_empty result.stdout
    assert_equal <<LOCKFILE, result.merged
GEM
  remote: https://rubygems.org/
  specs:
    rack (3.1.1)
    rack-test (2.1.0)
      rack (>= 1.3)

PLATFORMS
  arm64-darwin-24
  ruby

DEPENDENCIES
  rack (= 3.1.1)
  rack-test (= 2.1.0)

BUNDLED WITH
   2.5.16
LOCKFILE
  end


  Dir["#{FIXTURES}/rails/*"].each do |dir|
    test_name = File.basename(dir)
    define_method("test_#{test_name}") do
      result = run_merge(
        "#{dir}/a",
        "#{dir}/base",
        "#{dir}/b",
      )
      assert result.status.success?

      expected = File.read("#{dir}/merge")
      assert_equal expected, result.merged
    end
  end

  Result = Struct.new(:status, :stdout, :merged)

  def run_merge(local, base, remote)
    local = File.expand_path(local, FIXTURES)
    base = File.expand_path(base, FIXTURES)
    remote = File.expand_path(remote, FIXTURES)

    Dir.mktmpdir do |tmpdir|
      FileUtils.cp(local, "#{tmpdir}/local")
      FileUtils.cp(base, "#{tmpdir}/base")
      FileUtils.cp(remote, "#{tmpdir}/remote")

      argv = ["#{tmpdir}/local", "#{tmpdir}/base", "#{tmpdir}/remote"]
      #stdout = IO.popen([RbConfig.ruby, BIN, "", :err=>[:child, :out]]) do |io|
      stdout = IO.popen([RbConfig.ruby, BIN, *argv]) do |io|
        io.read
      end
      status = $?

      merged = File.read("#{tmpdir}/local")

      Result.new(status, stdout, merged)
    end
  end
end
