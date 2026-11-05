class Skyhold < Formula
  desc "Back up files to any cloud through rclone with an age-encrypted vault"
  homepage "https://github.com/Gitguy268/skyhold"
  url "https://github.com/Gitguy268/skyhold/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "5899f45e7be8ac164b69f1499f5c48bf39b612e94b2dc588b24aa00b08e488a9"
  license "MIT"
  head "https://github.com/Gitguy268/skyhold.git", branch: "main"

  depends_on "go" => :build
  depends_on "rclone"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/skyhold"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skyhold --version")
  end
end
