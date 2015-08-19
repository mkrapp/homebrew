class Embulk < Formula
  desc "Data transfer between various databases, file formats and services"
  homepage "http://www.embulk.org/"
  url "https://bintray.com/artifact/download/embulk/maven/embulk-0.7.1.jar"
  sha256 "c7ded3f9c40fa6f53a84da58a9737d67a8b544236a12a6d562838567391bc1c8"

  bottle do
    cellar :any
    sha256 "a2f5cecc6ce56ffe2a4f2260ddfc93c520e1ee6db23bbee68ceca6807e72cd1c" => :yosemite
    sha256 "0fa1e08a9faf1f1302c569881756001daffffce31c371c43bfb961bb0dc5e74e" => :mavericks
    sha256 "6decb163913f25365090cf6ce61cd5ab6a2b6e51be6bb6170e696c18880a0b7b" => :mountain_lion
  end

  depends_on :java

  skip_clean "libexec"

  def install
    (libexec/"bin").install "embulk-#{version}.jar" => "embulk"
    bin.write_jar_script libexec/"bin/embulk", "embulk"
  end

  test do
    system bin/"embulk", "example", "./try1"
    system bin/"embulk", "guess", "./try1/example.yml", "-o", "config.yml"
    system bin/"embulk", "preview", "config.yml"
    system bin/"embulk", "run", "config.yml"
  end
end
