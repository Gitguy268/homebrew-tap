class NeedlePlayer < Formula
  desc "Terminal music player with a TUI, inline mode, daemon and JSON-lines API"
  homepage "https://github.com/Gitguy268/needle"
  url "https://github.com/Gitguy268/needle/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "fed8c0e3594a00faa2ceb5f96faddb086175650a66ccde8e0c1a66528ba9eb16"
  license "MIT"
  head "https://github.com/Gitguy268/needle.git", branch: "main"

  depends_on "go" => :build

  on_linux do
    depends_on "mpv"
  end

  conflicts_with "needle", because: "both install a `needle` binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"needle")
  end

  def caveats
    on_macos do
      <<~EOS
        needle plays through mpv when it is installed, and falls back to afplay:
          brew install mpv
      EOS
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needle version")
  end
end
