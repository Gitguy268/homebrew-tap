class GhMerge < Formula
  desc "Merge every open pull request GitHub can merge, in one repo or all of them"
  homepage "https://github.com/Gitguy268/gh-merge"
  url "https://github.com/Gitguy268/gh-merge/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "fe4f074ea84bf7b2d7fed0fe94a55b64b31e1040c160e60af150823a9ee66e3a"
  license "MIT"
  head "https://github.com/Gitguy268/gh-merge.git", branch: "main"

  depends_on "go" => :build
  depends_on "gh"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  def caveats
    <<~EOS
      This installs the `gh-merge` command. It uses your gh login (gh auth login).
      gh only runs extensions it installed itself, so for `gh merge` run:
        gh extension install Gitguy268/gh-merge
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh-merge version")
    assert_match "gh merge --all", shell_output("#{bin}/gh-merge --help")
    assert_match "name: gh-merge", shell_output("#{bin}/gh-merge install-skill --print")
    assert_match "only one of", shell_output("#{bin}/gh-merge --all --owner x 2>&1", 1)
  end
end
