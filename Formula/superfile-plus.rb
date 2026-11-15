class SuperfilePlus < Formula
  desc "Fork of the superfile terminal file manager with extra fixes and features"
  homepage "https://github.com/Gitguy268/superfile"
  url "https://github.com/Gitguy268/superfile/archive/refs/tags/v1.6.0-gitguy.2.tar.gz"
  version "1.6.0-gitguy.2"
  sha256 "00939294cb58b93ae260db141e67ab0ea3eb543ef4b6cabe5eb865609c907570"
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
