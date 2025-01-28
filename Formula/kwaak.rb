class Kwaak < Formula
  desc "Run a team of autonomous agents on your code, right from your terminal"
  homepage "https://github.com/bosun-ai/kwaak"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bosun-ai/kwaak/releases/download/v0.7.0/kwaak-aarch64-apple-darwin.tar.xz"
      sha256 "d9d57cfb5ec1ffebb1eadb18ad7dba7af50c40ed6b4d8cdd8569b266674fcc2b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bosun-ai/kwaak/releases/download/v0.7.0/kwaak-x86_64-apple-darwin.tar.xz"
      sha256 "9f5daf5f227a02266cfb79cfc8e0112cf6f53c69fccf206437298b91719e0953"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bosun-ai/kwaak/releases/download/v0.7.0/kwaak-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "10426162183d8279b4fca323ca9ec54b552ec3c7311d7f637efcfd4c7beefe18"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "kwaak" if OS.mac? && Hardware::CPU.arm?
    bin.install "kwaak" if OS.mac? && Hardware::CPU.intel?
    bin.install "kwaak" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
