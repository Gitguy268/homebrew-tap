class Retrofind < Formula
  desc "Private 1998-style web search on your Mac over a local SearXNG"
  homepage "https://github.com/Gitguy268/retrofind"
  url "https://github.com/Gitguy268/retrofind/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "cb2c80949578832399fc5ff85e3ece46e6757d8a9fd76f1567221051bc06bef1"
  license "MIT"
  head "https://github.com/Gitguy268/retrofind.git", branch: "main"

  depends_on :macos
  depends_on "uv"

  def install
    libexec.install "server.py", "start.command", "web", "searxng"
    # The opt path stays the same across upgrades, so the LaunchAgents keep working.
    (bin/"retrofind").write <<~SH
      #!/bin/sh
      export PATH="#{HOMEBREW_PREFIX}/bin:$PATH"
      case "$1" in
        uninstall) exec sh "#{opt_libexec}/searxng/uninstall.sh" ;;
        *) exec sh "#{opt_libexec}/start.command" ;;
      esac
    SH
  end

  def caveats
    <<~EOS
      The first `retrofind` installs SearXNG into
        ~/Library/Application Support/Retrofind
      and two LaunchAgents that start it at login, then opens http://127.0.0.1:8898/
      Before `brew uninstall retrofind`, run `retrofind uninstall` to remove them.
    EOS
  end

  test do
    assert_match "Retrofind", (libexec/"web/index.html").read
    system "sh", "-n", libexec/"start.command"
    system "sh", "-n", libexec/"searxng/install.sh"
  end
end
