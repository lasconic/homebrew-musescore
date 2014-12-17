require "formula"

class Portaudio < Formula
  homepage "http://www.portaudio.com"
  url "http://www.portaudio.com/archives/pa_stable_v19_20140130.tgz"
  sha1 "526a7955de59016a06680ac24209ecb6ce05527d"
  head "https://subversion.assembla.com/svn/portaudio/portaudio/trunk/", :using => :svn

  depends_on "pkg-config" => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-mac-universal=#{build.universal? ? 'yes' : 'no'}"
                          "MACOSX_DEPLOYMENT_TARGET=10.8"
    system "make", "install"

    # Need 'pa_mac_core.h' to compile PyAudio
    include.install "include/pa_mac_core.h"
  end
end
