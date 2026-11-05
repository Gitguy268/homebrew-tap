class ContainerHere < Formula
  desc "Fork of apple/container with VMs in the terminal (`container here`) and a TUI"
  homepage "https://github.com/Gitguy268/container"
  url "https://github.com/Gitguy268/container/archive/refs/tags/1.5.0-here.1.tar.gz"
  version "1.5.0-here.1"
  sha256 "e29d4ec707c03dc58f77f163b77f7c3a24519431699ff5a5f69e4e8f5e3f869b"
  license "Apache-2.0"
  head "https://github.com/Gitguy268/container.git", branch: "main"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  conflicts_with "container", because: "both install a `container` binary"

  def install
    if build.head?
      ENV["GIT_COMMIT"] = Utils.git_head
    else
      ENV["RELEASE_VERSION"] = version
    end

    system "swift", "build", *std_swift_args
    release_dir = buildpath/".build/release"

    # The CLI finds its plugins from the lexical grandparent of the running
    # executable, so the real binaries sit one directory below the keg root
    # and bin/ holds small wrappers that run them through the opt path.
    exe = prefix/"exec"
    exe.install release_dir/"container", release_dir/"container-apiserver"
    codesign "--identifier=com.apple.container.cli", "--entitlements=signing/container-cli.entitlements",
             exe/"container"
    codesign "--identifier=com.apple.container.apiserver", exe/"container-apiserver"

    plugins = {
      "container-runtime-linux" => { source: "RuntimeLinux", entitlements: true },
      "container-network-vmnet" => { source: "NetworkVmnet", entitlements: true },
      "container-core-images"   => { source: "CoreImages" },
      "machine-apiserver"       => { source: "MachineAPIServer", resources: ["init"] },
      "k8s"                     => { source: "K8s", resources: ["kindnet.yaml"] },
      "build"                   => { source: "ContainerBuild", binary: "container-build" },
      "builder"                 => { source: "ContainerBuilder", binary: "container-builder" },
    }
    plugins.each do |name, opts|
      dir = libexec/"container/plugins"/name
      (dir/"bin").install release_dir/(opts[:binary] || name) => name
      dir.install "Sources/Plugins/#{opts[:source]}/config.toml"
      opts[:resources]&.each do |res|
        (dir/"resources").install "Sources/Plugins/#{opts[:source]}/Resources/#{res}"
      end
      args = ["--prefix=com.apple.container."]
      args << "--entitlements=signing/#{name}.entitlements" if opts[:entitlements]
      codesign(*args, dir/"bin"/name)
    end

    %w[container container-apiserver].each do |b|
      (bin/b).write_env_script opt_prefix/"exec"/b, CONTAINER_INSTALL_ROOT: opt_prefix
    end
  end

  def codesign(*args)
    system "/usr/bin/codesign", "-f", "-s", "-", *args
  end

  def caveats
    <<~EOS
      Start the services once (it offers to install the default Linux kernel):
        container system start
      Then boot a Linux VM right in your terminal:
        container here ubuntu bash
    EOS
  end

  test do
    assert_match "1.5.0", shell_output("#{bin}/container --version")
    assert_match "list", shell_output("#{bin}/container --help")
  end
end
