class UsbLlms < Formula
  desc "Run Ollama models from a USB stick, online or offline, with a TUI and web UI"
  homepage "https://github.com/Gitguy268/usb-llms"
  url "https://github.com/Gitguy268/usb-llms/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "9092b6d38a412e6ac85881e17ae2fead4cb26ea0dc8d6a37f83f0acc194fb48f"
  license "MIT"
  head "https://github.com/Gitguy268/usb-llms.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usb-llms version")
  end
end
