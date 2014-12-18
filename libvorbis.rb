require 'formula'

class Libvorbis < Formula
  homepage 'http://vorbis.com'
  url 'http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.xz'
  sha1 'b99724acdf3577982b3146b9430d765995ecf9e1'

  head do
    url 'http://svn.xiph.org/trunk/vorbis'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'lasconic/musescore/libogg'

  def install
    ENV.universal_binary if build.universal?
    ENV.append "CFLAGS", "-O2 -g -Wall -arch x86_64 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk -mmacosx-version-min=10.8"
    ENV.append "LDFLAGS", "-arch x86_64 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk -mmacosx-version-min=10.8"

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
                          "MACOSX_DEPLOYMENT_TARGET=10.8"
    system "make install"
  end
end
