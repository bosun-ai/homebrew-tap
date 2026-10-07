class Smackdebt < Formula
  desc "Find costly code debt and see whether your changes make it better"
  homepage "https://github.com/bosun-ai/smackdebt"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bosun-ai/smackdebt/releases/download/v0.2.0/smackdebt-aarch64-apple-darwin.tar.xz"
      sha256 "417573589d279eccfd07a1a70006f067b1659db2cd65669d1ab255b8f219e482"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bosun-ai/smackdebt/releases/download/v0.2.0/smackdebt-x86_64-apple-darwin.tar.xz"
      sha256 "1963d816ecd409b47a22924bba7ce03e4b522fe98142930af3725b0698f2d346"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/bosun-ai/smackdebt/releases/download/v0.2.0/smackdebt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8da8e81ebe4f754c5f75dd499dd5acc188810fd6585cccd12c7293d0f2c0b422"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "smackdebt"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "smackdebt"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "smackdebt"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
