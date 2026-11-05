class Tabshell < Formula
  desc "Real Linux terminal in a browser tab, powered by v86 or Docker"
  homepage "https://github.com/Gitguy268/tabshell"
  url "https://github.com/Gitguy268/tabshell/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "eb5a81cc44b0af86a3985a4c6b5e576accfa5ce35ac3a2e5ee25b19b15b3d2fe"
  license "MIT"

  depends_on "node"

  # The built site with the Alpine browser-VM image; building that image needs Docker.
  resource "dist" do
    url "https://github.com/Gitguy268/tabshell/releases/download/v1.0.0/tabshell-dist-1.0.0.tar.gz"
    sha256 "81ca33aee1532aa85e37c52aae073455b022dfc433d32cc77883560c24e82d47"
  end

  def install
    libexec.install "server.mjs", "package.json", "docker", "tools"
    (libexec/"dist").install resource("dist")
    (bin/"tabshell").write <<~SH
      #!/bin/sh
      case "$1" in
        docker-image)
          # One-time build of the Ubuntu image used by Docker mode.
          exec docker build -t tabshell-ubuntu -f "#{opt_libexec}/docker/Dockerfile" "#{opt_libexec}" ;;
        *)
          # The real path: server.mjs only listens when argv[1] matches its own resolved path.
          exec "#{formula_opt_bin("node")}/node" "#{libexec}/server.mjs" "$@" ;;
      esac
    SH
  end

  def caveats
    <<~EOS
      Run `tabshell` and open http://localhost:8686/ for the browser VM.
      For Docker mode, start Docker (or apple/container) and build its image once:
        tabshell docker-image
    EOS
  end

  test do
    port = free_port
    pid = spawn({ "PORT" => port.to_s }, bin/"tabshell")
    sleep 3
    assert_match "TabShell", shell_output("curl -s http://localhost:#{port}/")
    assert_match "fsroot", shell_output("curl -s http://localhost:#{port}/alpine/fs.json | head -c 200")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
