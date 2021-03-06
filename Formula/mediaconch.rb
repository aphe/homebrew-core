class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/16.03/MediaConch_CLI_16.03_GNU_FromSource.tar.bz2"
  version "16.03"
  sha256 "05c8ec1f883bb30b84102b13e3ecb8303c2250824a471fa3c12abf10b2546892"

  bottle do
    cellar :any
    sha256 "d8dd10b5d7f927c48a0b88a426b5be49408bae68c739e4e40e3043636310ab41" => :el_capitan
    sha256 "e93d19673b2b79ee7ea0e17df2b6aaa557d3123f27a98deb25fdd00bcbfdbf2b" => :yosemite
    sha256 "5e17bb21ae3f41b8cbf148457f31ec9229909f439c2969864d3b3ece47d809bc" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libevent"
  depends_on "sqlite"
  # fails to build against Leopard's older libcurl
  depends_on "curl" if MacOS.version < :snow_leopard
  depends_on "libxslt" unless OS.mac?

  def install
    cd "ZenLib/Project/GNU/Library" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--with-libcurl",
              "--prefix=#{prefix}",
              # mediaconch installs libs/headers at the same paths as mediainfo
              "--libdir=#{lib}/mediaconch",
              "--includedir=#{include}/mediaconch"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaConch/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediaconch", test_fixtures("test.mp3"))
  end
end
