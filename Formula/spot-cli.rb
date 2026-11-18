class SpotCli < Formula
  desc "Black lab who lives in your terminal and wags when your tests pass"
  homepage "https://github.com/Gitguy268/spot-cli"
  url "https://github.com/Gitguy268/spot-cli/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "cf6f816f49dae7995b451d28e439f9f527fac9356feb28618af7254006b4bd9a"
  license "MIT"
  head "https://github.com/Gitguy268/spot-cli.git", branch: "main"

  depends_on "go" => :build

  conflicts_with "spot", because: "both install a `spot` binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}", output: bin/"spot"), "./cmd/spot"
  end

  def caveats
    <<~EOS
      Bring Spot home by adding one line to your shell config:
        zsh:  eval "$(spot init zsh --prompt)"      in ~/.zshrc
        bash: eval "$(spot init bash --prompt)"     in ~/.bashrc
        fish: spot init fish --prompt | source       in config.fish
    EOS
  end

  test do
    ENV["SPOT_HOME"] = testpath/"state"
    ENV["SPOT_CONFIG"] = testpath/"config"
    assert_match version.to_s, shell_output("#{bin}/spot version")
    system bin/"spot", "run", "--", "true"
    assert_match '"passes": 1', shell_output("#{bin}/spot status --json")
    assert_match "_event", shell_output("#{bin}/spot init zsh")
  end
end
