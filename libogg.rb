require 'formula'

class Libogg < Formula
  homepage 'https://www.xiph.org/ogg/'
  url 'http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz'
  sha1 'df7f3977bbeda67306bc2a427257dd7375319d7d'

  head do
    url 'https://svn.xiph.org/trunk/ogg'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
                          "MACOSX_DEPLOYMENT_TARGET=10.8"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
