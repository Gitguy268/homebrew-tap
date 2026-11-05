class Pakket < Formula
  desc "Terminal archiver: compress, extract and encrypt 7z, zip, rar, dmg, tar and more"
  homepage "https://github.com/Gitguy268/pakket"
  url "https://github.com/Gitguy268/pakket/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2e407ea2fc6c6b83cd2c89b3085255a40f66e2e16155c9d4fad7c98d5b093cdf"
  license "MIT"
  head "https://github.com/Gitguy268/pakket.git", branch: "main"

  depends_on "go" => :build
  depends_on "sevenzip"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  def caveats
    <<~EOS
      Optional extras for more formats:
        brew install unar    # StuffIt, Compact Pro, InstallShield 3
        brew install lrzip   # .lrz
      Run `pakket formats` to see what works on this machine.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pakket version")
    (testpath/"in/a.txt").write "hello pakket"
    ENV["XDG_CONFIG_HOME"] = testpath/"config"
    ENV["PAKKET_PASSWORD"] = "secret"
    system bin/"pakket", "compress", "-q", "-f", "7z", "-o", testpath/"t.7z", testpath/"in"
    system bin/"pakket", "test", testpath/"t.7z"
    system bin/"pakket", "extract", "-q", "-d", testpath/"out", testpath/"t.7z"
    assert_equal "hello pakket", (testpath/"out/in/a.txt").read
  end
end
