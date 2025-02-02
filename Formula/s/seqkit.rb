class Seqkit < Formula
  desc "Cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang"
  homepage "https://bioinf.shenwei.me/seqkit"
  url "https://github.com/shenwei356/seqkit/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "db9b39afb9bbb5148f30616ec91ba0d8b15eede27dc5dfbca194c75b4fa846d4"
  license "MIT"
  head "https://github.com/shenwei356/seqkit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a667b0ba532d938f2a50cde694676a267df3bdc3cd4373065049c040a53df21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a667b0ba532d938f2a50cde694676a267df3bdc3cd4373065049c040a53df21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a667b0ba532d938f2a50cde694676a267df3bdc3cd4373065049c040a53df21"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8d013ebb699fec9bcf07a497e238989edeff2e463edbd64ab68ee786c9e940d"
    sha256 cellar: :any_skip_relocation, ventura:       "e8d013ebb699fec9bcf07a497e238989edeff2e463edbd64ab68ee786c9e940d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfc3a16988726cb99ba2120971dfab1c23d3a1752b2b57e7651fcf6c014ef9b5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./seqkit"
  end

  test do
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/shenwei356/seqkit/e37d70a7e0ca0e53d6dbd576bd70decac32aba64/tests/seqs4amplicon.fa"
      sha256 "b0f09da63e3c677cc698d5cdff60e2d246368263c22385937169a9a4c321178a"
    end

    resource("homebrew-testdata").stage do
      assert_equal ">seq1\nCCCACTGAAA",
      shell_output("#{bin}/seqkit amplicon --quiet -F CCC -R TTT seqs4amplicon.fa").strip
    end
  end
end
