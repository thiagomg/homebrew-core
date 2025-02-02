class GoogleJavaFormat < Formula
  include Language::Python::Shebang

  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/releases/download/v1.25.0/google-java-format-1.25.0-all-deps.jar"
  sha256 "8bd949e84a6435046cf18ddfa769661eaac9da21b2d3ca46c4ba12f96637bcbb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "118884cbe71c478ea2fdf3fded16a6e753ae8186a9d6cf6e2795d7f021852e6f"
  end

  depends_on "openjdk"

  uses_from_macos "python"

  resource "google-java-format-diff" do
    url "https://raw.githubusercontent.com/google/google-java-format/v1.25.0/scripts/google-java-format-diff.py"
    sha256 "c1f2c6e8af0fc34a04adfcb01b35e522a359df5da1f5db5102ca9e0ca1f670fd"
  end

  def install
    if version != resource("google-java-format-diff").version
      odie "google-java-format-diff resource needs to be updated"
    end

    libexec.install "google-java-format-#{version}-all-deps.jar" => "google-java-format.jar"
    bin.write_jar_script libexec/"google-java-format.jar", "google-java-format"
    resource("google-java-format-diff").stage do
      rewrite_shebang detected_python_shebang(use_python_from_path: true), "google-java-format-diff.py"
      bin.install "google-java-format-diff.py" => "google-java-format-diff"
    end
  end

  test do
    (testpath/"foo.java").write "public class Foo{\n}\n"

    assert_match "public class Foo {}", shell_output("#{bin}/google-java-format foo.java")

    (testpath/"bar.java").write <<~BAR
      class Bar{
        int  x;
      }
    BAR

    patch = <<~PATCH
      --- a/bar.java
      +++ b/bar.java
      @@ -1,0 +2 @@ class Bar{
      +  int x  ;
    PATCH
    `echo '#{patch}' | #{bin}/google-java-format-diff -p1 -i`
    assert_equal <<~BAR, File.read(testpath/"bar.java")
      class Bar{
        int x;
      }
    BAR
  end
end
