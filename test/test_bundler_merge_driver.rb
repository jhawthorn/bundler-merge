require "minitest/autorun"

class TestBundlerMergeDriver < Minitest::Test
  FIXTURES = File.expand_path("fixtures", __dir__)
  BIN = File.expand_path("../bin/bundler-merge-driver", __dir__)

  def test_foo
    p BIN

    result = run_merge(
      "rack_and_rack_test/Gemfile.lock.orig",
      "rack_and_rack_test/Gemfile.lock.rack",
      "rack_and_rack_test/Gemfile.lock.rack-test",
    )
  end

  Result = Struct.new(:status, :stdout, :merged)

  def run_merge(base, local, remote)
    Dir.mktmpdir do |tmpdir|
      FileUtils.cp("#{FIXTURES}/#{base}", "#{tmpdir}/base")
      FileUtils.cp("#{FIXTURES}/#{local}", "#{tmpdir}/local")
      FileUtils.cp("#{FIXTURES}/#{remote}", "#{tmpdir}/remote")

      argv = ["#{tmpdir}/base", "#{tmpdir}/local", "#{tmpdir}/remote"]
      #stdout = IO.popen([RbConfig.ruby, BIN, "", :err=>[:child, :out]]) do |io|
      stdout = IO.popen([RbConfig.ruby, BIN, *argv]) do |io|
        io.read
      end
      status = $?

      merged = File.read("#{tmpdir}/local")

      puts stdout

      Result.new(status, stdout, merged)
    end
  end
end
