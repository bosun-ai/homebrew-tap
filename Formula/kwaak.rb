class Kwaak < Formula
  desc "Run a team of autonomous agents on your code, right from your terminal"
  homepage "https://github.com/bosun-ai/kwaak"
  version "0.16.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bosun-ai/kwaak/releases/download/v0.16.2/kwaak-aarch64-apple-darwin.tar.xz"
      sha256 "50e79c490daba496555cbaea583eed63d40226fa805bd14a5e5370731ad760c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bosun-ai/kwaak/releases/download/v0.16.2/kwaak-x86_64-apple-darwin.tar.xz"
      sha256 "4b6b022ddc09cdb8a27f9ee99a08326dfd13514140b0ff9dca05466d954e6cf1"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bosun-ai/kwaak/releases/download/v0.16.2/kwaak-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "aeebc2d7e308772142678bff33a12618db8825b24f5f7ee42b4fd6c4b7c0b2e8"
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
