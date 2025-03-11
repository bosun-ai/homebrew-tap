class Kwaak < Formula
  desc "Run a team of autonomous agents on your code, right from your terminal"
  homepage "https://github.com/bosun-ai/kwaak"
  version "0.15.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bosun-ai/kwaak/releases/download/v0.15.0/kwaak-aarch64-apple-darwin.tar.xz"
      sha256 "31d461472d33fd9ae247b764ff8c5c5df2aed681a93be94bf2239aebe3034170"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bosun-ai/kwaak/releases/download/v0.15.0/kwaak-x86_64-apple-darwin.tar.xz"
      sha256 "2d0a0860a220b82295d78f3c1a4f9b57a4f4ecbb465788c358cd60203827f4f9"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bosun-ai/kwaak/releases/download/v0.15.0/kwaak-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5b45bbd4926f32be760cfeebf206a2ef513c83f96928a4f8348dadc0e1daff1f"
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
