class Kwaak < Formula
  desc "Run a team of autonomous agents on your code, right from your terminal"
  homepage "https://github.com/bosun-ai/kwaak"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bosun-ai/kwaak/releases/download/v0.12.0/kwaak-aarch64-apple-darwin.tar.xz"
      sha256 "fb4d1f1628055eaa54e0bca81d00588c075d4611e2846bc1fac294b4837b507b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bosun-ai/kwaak/releases/download/v0.12.0/kwaak-x86_64-apple-darwin.tar.xz"
      sha256 "ee1a5e0088be3fa8db3d82088fe8f90d7a50fe92ac5a096f41237a96facfc7d4"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bosun-ai/kwaak/releases/download/v0.12.0/kwaak-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "52aea59b0f24fbf00e56887bd9a1167b43d0edc59fc0d0de8f4088464e48a7be"
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
