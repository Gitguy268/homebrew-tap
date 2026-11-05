class SuperfilePlus < Formula
  desc "Fork of the superfile terminal file manager with extra fixes and features"
  homepage "https://github.com/Gitguy268/superfile"
  url "https://github.com/Gitguy268/superfile/archive/refs/tags/v1.6.0-gitguy.1.tar.gz"
  version "1.6.0-gitguy.1"
  sha256 "97fa51039782775b9187b4cc155e2d41a1d01bf25944e76d0690549a0ef9bfa1"
  license "MIT"
  head "https://github.com/Gitguy268/superfile.git", branch: "improvements"

  depends_on "go" => :build

  conflicts_with "superfile", because: "both install an `spf` binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"spf")
  end

  test do
    assert_match "1.6.0", shell_output("#{bin}/spf -v")
  end
end
