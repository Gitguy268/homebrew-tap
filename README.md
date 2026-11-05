<div align="center">

# Gitguy268 Homebrew tap

Homebrew formulas for my apps that run on your own machine: terminal tools, local servers and desktop apps.

![License: MIT](https://img.shields.io/badge/license-MIT-blue)
![macOS · Linux](https://img.shields.io/badge/os-macOS%20%C2%B7%20Linux-555)

</div>

## Install

Homebrew asks you to trust a tap before it loads formulas from it. Do that once, then install what you want:

```sh
brew trust gitguy268/tap
brew install gitguy268/tap/pakket
```

Or `brew tap gitguy268/tap` and then `brew install <formula>`. In a `Brewfile`:

```ruby
tap "gitguy268/tap"
brew "pakket"
```

Every formula builds from the tagged source on GitHub; there are no prebuilt bottles yet. Each one was built and tested with `brew install --build-from-source` and `brew test` on macOS 27 (Apple silicon). The Linux entries below are what the formulas allow; Homebrew on Linux has not been tried with them yet.

## Formulas

| Formula | Command | What it is | Platforms (tested on macOS) |
|---|---|---|---|
| [pakket](https://github.com/Gitguy268/pakket) | `pakket` | Terminal archiver: 7z, zip, rar, dmg, tar, zstd, age and more, with a TUI | macOS, Linux |
| [needle-player](https://github.com/Gitguy268/needle) | `needle` | Terminal music player: TUI, inline mode, daemon, JSON lines | macOS, Linux |
| [skyhold](https://github.com/Gitguy268/skyhold) | `skyhold` | Back up to any cloud through rclone with an age-encrypted vault | macOS, Linux |
| [usb-llms](https://github.com/Gitguy268/usb-llms) | `usb-llms` | Run Ollama models from a USB stick, online or offline | macOS, Linux |
| [textarea-cli](https://github.com/Gitguy268/textarea-cli) | `text` | Markdown notes in the terminal, synced with Textarea, Obsidian and Apple Notes | macOS, Linux |
| [superfile-plus](https://github.com/Gitguy268/superfile) | `spf` | My superfile fork: file manager with extra fixes and features | macOS, Linux |
| [lvw-harness](https://github.com/Gitguy268/LvW-harness) | `lvw` | Local-first AI agent with a model manager, terminal and web UI | macOS, Linux |
| [web2app](https://github.com/Gitguy268/web2app) | `web2app` | Web GUI for Pake: turn a website into a desktop app | macOS, Linux |
| [tabshell](https://github.com/Gitguy268/tabshell) | `tabshell` | A real Linux terminal in a browser tab: Alpine in v86, or Ubuntu through Docker | macOS, Linux |
| [retrofind](https://github.com/Gitguy268/retrofind) | `retrofind` | Private 1998-style web search over a local SearXNG | macOS |
| [container-here](https://github.com/Gitguy268/container) | `container` | My apple/container fork with `container here` and a TUI | macOS, Apple silicon |
| [glyphium](https://github.com/Gitguy268/glyphium) | `glyphium` | GPU terminal emulator on libghostty-vt (early) | macOS |

`needle-player`, `superfile-plus` and `container-here` have different names from the projects in homebrew-core (`needle`, `superfile`, `container`), and conflict with them, because they install the same commands.

## Not here

My browser apps and games already run on their project pages, so they have no formula. See [gitguy268.github.io](https://gitguy268.github.io).

## License

The formulas are [MIT](LICENSE). Each app has its own licence, shown in its formula.
