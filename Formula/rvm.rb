class Rvm < Formula
  desc "Manage multiple Ruby environments"
  homepage "https://rvm.io"
  url "https://github.com/rvm/rvm/archive/1.29.7.tar.gz"
  mirror "https://bitbucket.org/mpapis/rvm/get/1.29.7.tar.gz"
  sha256 "48148248d964f1e6e54bb9b754dc4b93e658bc6b3223fcb5f3b219658f6772c6"
  head "https://github.com/rvm/rvm.git"

  bottle :unneeded

  def install
    system "./install", "--path", "#{buildpath}/output", "--ignore-dotfiles"
    prefix.install "output"
    man1.install "man/man1/rvm.1"
  end

  def caveats; <<~EOS
    Add the following to #{shell_profile} or your desired shell
    configuration file:
      export rvm_path="#{opt_prefix}/output"
      source $rvm_path/scripts/rvm

    Type `rvm help` for further information.
  EOS
  end

  test do
    ENV["rvm_path"] = "#{opt_prefix}/output"
    output = pipe_output("bash -c \"source $rvm_path/scripts/rvm; rvm list 2>&1\"")
    assert_no_match /No such file or directory/, output
    assert_no_match /rvm: command not found/, output
    assert_match "No rvm rubies installed yet. Try 'rvm help install'.", output
  end
end
