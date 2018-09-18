class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v18.9.10.94.tar.gz"
  sha256 "dcb98b9b71f228ee8c35d18a40c703badf697fd04d3ff50d5e09871027b9d02e"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "e22f2f83d23b8158bdc83552dcfcabfb594a6c526e7741e115b5f784cff4193d" => :mojave
    sha256 "cc4614def8e563ae2bc0440c112f6a52d3a9de49ec8d8b812dbf50c92aca0916" => :high_sierra
    sha256 "181da84c21efeb9ee8b83cc06820c9383db50d2b9e73c163d5bd4d8597be44f7" => :sierra
    sha256 "b06a44335b3153ec53c260db673f71116d12e70312ce32a5f6afa59caca382c3" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_predicate testpath/"config", :exist?
  end
end
