class Kwaak < Formula
  desc "Run a team of autonomous agents on your code, right from your terminal"
  homepage "https://github.com/bosun-ai/kwaak"
  version "0.11.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bosun-ai/kwaak/releases/download/v0.11.2/kwaak-aarch64-apple-darwin.tar.xz"
      sha256 "e056abcf9c2fec79a79c63fc5b13ed9843b24bb852003891cadfcc27d8809ace"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bosun-ai/kwaak/releases/download/v0.11.2/kwaak-x86_64-apple-darwin.tar.xz"
      sha256 "745c217cb71bfd07998a6b33221358a6e69e97fa2b1566587a72cd71521b83e0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bosun-ai/kwaak/releases/download/v0.11.2/kwaak-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "405b0f892b9b310469b61550d5629283ad4801b67ae8c8e0101a017d77d7592d"
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
