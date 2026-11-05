class Web2app < Formula
  desc "Local web GUI for Pake that turns any website into a desktop app"
  homepage "https://github.com/Gitguy268/web2app"
  url "https://github.com/Gitguy268/web2app/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "42b7826a922f753438d7ccab35c87ce93ece065d14b37b3b1a1c12044a1ad9f3"
  license "GPL-3.0-or-later"
  head "https://github.com/Gitguy268/web2app.git", branch: "main"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    # Install scripts are skipped above; this one links Tauri where Pake looks for it.
    system "sh", "scripts/link-tauri.sh"
    libexec.install Dir["*"]
    data = OS.mac? ? "$HOME/Library/Application Support/web2app" : "${XDG_DATA_HOME:-$HOME/.local/share}/web2app"
    (bin/"web2app").write <<~SH
      #!/bin/sh
      # Builds and their history live outside the Homebrew keg, so upgrades keep them.
      : "${WEB2APP_BUILDS:=#{data}/builds}"
      export WEB2APP_BUILDS
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/server.js" "$@"
    SH
  end

  def caveats
    <<~EOS
      Pake needs Rust to build apps: install it with rustup (https://rustup.rs)
      or `brew install rust`. Then run `web2app` and open http://localhost:7417/
    EOS
  end

  test do
    port = free_port
    pid = spawn({ "PORT" => port.to_s, "WEB2APP_BUILDS" => (testpath/"builds").to_s }, bin/"web2app")
    sleep 3
    assert_match "web2app", shell_output("curl -s http://localhost:#{port}/")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
