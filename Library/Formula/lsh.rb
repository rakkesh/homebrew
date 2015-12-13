class Lsh < Formula
  desc "GNU implementation of the Secure Shell (SSH) protocols"
  homepage "https://www.lysator.liu.se/~nisse/lsh/"
  url "http://ftpmirror.gnu.org/lsh/lsh-2.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/lsh/lsh-2.1.tar.gz"
  sha256 "8bbf94b1aa77a02cac1a10350aac599b7aedda61881db16606debeef7ef212e3"

  bottle do
    revision 1
    sha256 "5ade7c67942a35410f130ef1fb76548161e3be2dc22307d2ddc77d21fa24b2ef" => :el_capitan
    sha256 "ef1ee7f5b0cc58ef8820924f46f2a82f6c72c373317cbca4ff3567499a86e59b" => :yosemite
    sha256 "620b97949d1fb024fcf5019455e1cb4d28b9ad498aadcf2d1aac4fa67735fd40" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :x11 => :optional # For libXau library
  depends_on "nettle"
  depends_on "gmp"

  resource "liboop" do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libo/liboop/liboop_1.0.orig.tar.gz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libo/liboop/liboop_1.0.orig.tar.gz"
    sha256 "34d83c6e0f09ee15cb2bc3131e219747c3b612bb57cf7d25318ab90da9a2d97c"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/0c197c83fa04bc99629520ba47c9f757e9ffd5a4.diff"
    sha256 "7a4f763e004313c7e36186a843964d1e3a3e6d940b0dc3a7284fa49a5163e5f4"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/b782b3abcf3b74d7b6bc0a89de988e1866e9a1a2.diff"
    sha256 "cda00077a101b31437883e6001c1a705483112ce6fbf9916789564f0bb4b2d6f"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/faf69a2890e5457b3bd4c2efe8d52ae0f00c2562.diff"
    sha256 "63040afd415141b0f1673b9fb4757b92fa0c982c3582ad689c3124e4be38c73d"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/dfe2b20109ffacef2b58fa530db820ecf34892b3.diff"
    sha256 "9f3120d0026d348fcf93016f64e3e3433c1dc10dbb412feb3a191ac64d4c3c5b"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/9849e9c2b77624f078c164f7cc15f51e586587b4.diff"
    sha256 "5d73e11e0ed743d1996f7ea5a796fe79ae2072f2ccfe7a959b09dfdb5934bfdc"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/2ecdd4f40399eda862ed57a5d6c6ed0bb0eeccb4.diff"
    sha256 "1f079c6cab2984fbc25dc51138d1698729d80e0ac0fa4620ca43259ae62b255b"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/6d5f1995f9c3439ca7f608eca680e3248df9790a.diff"
    sha256 "6a187f6d10186b40c4a0d0f069403b43a3a7f526d05f4dc190dd1b9fd5f5d31b"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/32fc8525ee4828e49859ae2822a2bdc0a5901398.diff"
    sha256 "8c48fe31b0237ee7d20851f9b5566d8956d2d8e90238f207fb2587110c6b00df"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/eefce110414b0eff1c70039179e1f6fc8968bb31.diff"
    sha256 "641b16d7223fcaf64771e9a9a94ef4e4bb6e90150185c3114b910a4bb200b1a3"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/3e3fce2bb20be32981d603e9c1c1af3dcc288752.diff"
    sha256 "adbd515b9b177f4b450cd3c8c4a992a713852a948d508fce4c7a1b23db15287c"
  end

  patch do
    url "https://git.lysator.liu.se/lsh/lsh/commit/a8f3f42bbeb2fad5ce8bda97abeb6b6de8c46b92.diff"
    sha256 "989eb64bd3e1510be0392caffb0e35afa085ed38520cb76d0231ce6adaee821d"
  end

  def install
    resource("liboop").stage do
      system "./configure", "--prefix=#{libexec}/liboop", "--disable-dependency-tracking",
                            "--without-tcl", "--without-readline", "--without-glib"
      system "make", "install"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end

    # Find the sandboxed liboop.
    ENV.append "LDFLAGS", "-L#{libexec}/liboop/lib"
    # Compile fails without passing gnu89.
    ENV.append_to_cflags "-I#{libexec}/liboop/include -std=gnu89"

    system "autoreconf", "-i"
    system "./configure", *args
    system "make", "install"
    # To avoid bumping into Homebrew/Dupes' OpenSSH:
    rm "#{man8}/sftp-server.8"
  end

  test do
    system "#{bin}/lsh", "--list-algorithms"
  end
end
