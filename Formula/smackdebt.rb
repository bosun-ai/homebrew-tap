class Smackdebt < Formula
  desc "Find costly code debt and see whether your changes make it better"
  homepage "https://github.com/bosun-ai/smackdebt"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bosun-ai/smackdebt/releases/download/v0.3.0/smackdebt-aarch64-apple-darwin.tar.xz"
      sha256 "b5bc3e70a6c80e739d839c8e02922b112b93d678d2a74401c75e83193078ee13"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bosun-ai/smackdebt/releases/download/v0.3.0/smackdebt-x86_64-apple-darwin.tar.xz"
      sha256 "fb2ef4731ab8a1a34c13149949fdcd3146f644e31c62f9aac93b15aa6b0e2469"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/bosun-ai/smackdebt/releases/download/v0.3.0/smackdebt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b9a8f275f80acc07e1ab243f6900362484bfc0a24ab20318403e47e5b14b820e"
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
