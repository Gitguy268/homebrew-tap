class TextareaCli < Formula
  desc "Markdown notes in the terminal, synced with Textarea, Obsidian and Apple Notes"
  homepage "https://github.com/Gitguy268/textarea-cli"
  url "https://github.com/Gitguy268/textarea-cli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "b360e214fb91ffee23e5089808f76fae3ab90b497a82f24db8f337ebed8b81de"
  license "MIT"
  head "https://github.com/Gitguy268/textarea-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"text"), "./cmd/text"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/text --version")
  end
end
