class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/3.0.0.tar.gz"
  sha256 "1c0661f0ae5f4e2874da250b60cd515e4ac4c041583221adfe95f10e18d1a4e6"
  license "GPL-2.0"
  head "https://github.com/htop-dev/htop.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "c06ff60960f64f5c8395f53d7419cbcce2a22ee87f0cb0138352c8a88111d21c" => :catalina
    sha256 "77aa302765353b4085dcad52356d3264183e06310dda8d5bac64642299ea2902" => :mojave
    sha256 "0ebfb655b91566ba31f8effc94d642a43305ff95bdc9b30b46fadc132e2ced0c" => :high_sierra
    sha256 "ed93b86f011de155c5d261b8c9cc9cb81fd0017667bf3ebe26ee090716bcd650" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "ncurses" # enables mouse scroll

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      htop requires root privileges to correctly display all running processes,
      so you will need to run `sudo htop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    pipe_output("#{bin}/htop", "q", 0)
  end
end
