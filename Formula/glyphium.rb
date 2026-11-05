class Glyphium < Formula
  desc "GPU-rendered terminal emulator built on libghostty-vt (early development)"
  homepage "https://github.com/Gitguy268/glyphium"
  url "https://github.com/Gitguy268/glyphium/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "419180bf0efd2b6c65a42f4fc856b1f6a1dea67bce6a55eeddca938080d03930"
  license "MIT"
  head "https://github.com/Gitguy268/glyphium.git", branch: "main"

  depends_on "rust" => :build
  depends_on "zig" => :build
  depends_on :macos

  # The terminal core: libghostty-vt from Ghostty, at the commit glyphium is tested with.
  resource "ghostty" do
    url "https://github.com/ghostty-org/ghostty.git",
        revision: "cec8b92f1ecd176a20a56aa405021e7ae991b996"
  end

  def install
    (buildpath/".tools/ghostty").install resource("ghostty")
    cd ".tools/ghostty" do
      # No xcframework: it needs full Xcode, and glyphium links the static library.
      system "zig", "build", "-Demit-lib-vt", "-Demit-xcframework=false", "-Doptimize=ReleaseFast"
    end
    system "cargo", "install", *std_cargo_args(path: "apps/desktop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/glyphium --version")
  end
end
