require "formula"

class Flac < Formula
  homepage "https://xiph.org/flac/"
  url "http://downloads.xiph.org/releases/flac/flac-1.3.1.tar.xz"
  sha1 "38e17439d11be26207e4af0ff50973815694b26f"

  head do
    url "https://git.xiph.org/flac.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libogg" => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  fails_with :clang do
    build 500
    cause "Undefined symbols ___cpuid and ___cpuid_count"
  end

  def install
    ENV.universal_binary if build.universal?

    ENV.append "CFLAGS", "-std=gnu89"

    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-sse
      --enable-static
    ]

    args << "--disable-asm-optimizations" if build.universal? || Hardware.is_32_bit?
    args << "--without-ogg" if build.without? "libogg"
    args << "MACOSX_DEPLOYMENT_TARGET=10.8"
    #args << "SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/"

    system "./autogen.sh" if build.head?
    system "./configure", *args

    ENV["OBJ_FORMAT"] = "macho"

    # adds universal flags to the generated libtool script
    inreplace "libtool" do |s|
      s.gsub! ":$verstring\"", ":$verstring -arch #{Hardware::CPU.arch_32_bit} -arch #{Hardware::CPU.arch_64_bit}\""
    end

    system "make", "install"
  end
end
