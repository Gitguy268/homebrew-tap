cask "lvw-bench-app" do
  version "0.1.0"
  sha256 "a13228b6bc715bdc737f6ee4f5e36944b2b4eb6b9bfcd538c04be5c261db4b24"

  url "https://github.com/Gitguy268/LvW-bench/releases/download/v#{version}/LvW-bench-#{version}-macos-universal.zip"
  name "LvW-bench"
  desc "Desktop app for a local benchmark of tiny AI models"
  homepage "https://github.com/Gitguy268/LvW-bench"

  depends_on macos: ">= :big_sur"

  app "LvW-bench.app"

  # The release build is not notarised; clear the download quarantine so it opens.
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/LvW-bench.app"]
  end

  zap trash: [
    "~/Library/Caches/lvw-bench",
    "~/Library/WebKit/LvW-bench",
  ]

  caveats <<~EOS
    LvW-bench is not signed by Apple. The cask removes the quarantine flag after install.
    The app runs models through llama.cpp and uv:
      brew install llama.cpp uv
  EOS
end
