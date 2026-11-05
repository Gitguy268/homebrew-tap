class LvwHarness < Formula
  desc "Local-first AI agent with a model manager, terminal and web UI"
  homepage "https://github.com/Gitguy268/LvW-harness"
  url "https://github.com/Gitguy268/LvW-harness/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "473ac7ecde66c735898c3a9e544672882a875ada4e5a63c15d3fd9e9502d0183"
  license "MIT"
  head "https://github.com/Gitguy268/LvW-harness.git", branch: "main"

  depends_on "bun" => :build

  def install
    system "bun", "install", "--frozen-lockfile"
    system "bun", "scripts/build.ts"
    bin.install "dist/lvw"
  end

  def caveats
    <<~EOS
      Set it up once (downloads llama-server and offers a starter model):
        lvw setup
      Then run `lvw`, or `lvw serve` for the web UI at http://127.0.0.1:7878/
    EOS
  end

  test do
    ENV["LVW_HOME"] = testpath/".lvw"
    assert_match version.to_s, shell_output("#{bin}/lvw --version")
  end
end
