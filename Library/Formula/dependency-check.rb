class DependencyCheck < Formula
  desc "OWASP Dependency Check"
  homepage "https://www.owasp.org/index.php/OWASP_Dependency_Check"
  url "https://dl.bintray.com/jeremy-long/owasp/dependency-check-1.3.2-release.zip"
  version "1.3.2"
  sha256 "de692f30f19aa250ad4cbecbda960573500eea7f18df36fbafe7c4d0a60f8c44"

  bottle :unneeded

  depends_on :java

  def install
    rm_f Dir["bin/*.bat"]

    chmod 0755, "bin/dependency-check.sh"

    prefix.install_metafiles
    libexec.install Dir["*"]

    File.rename "#{libexec}/bin/dependency-check.sh", \
      "#{libexec}/bin/dependency-check"
    bin.install_symlink libexec/"bin/dependency-check"

    (var/"dependencycheck").mkpath
    libexec.install_symlink var/"dependencycheck" => "data"

    (etc/"dependencycheck").mkpath
    corejar = libexec/"repo/org/owasp/dependency-check-core/#{version}/"\
      "dependency-check-core-#{version}.jar"
    system "unzip", "-o", corejar, "dependencycheck.properties", "-d", \
      libexec/"etc"
    etc.install_symlink libexec/"etc/dependencycheck.properties" => \
      "dependencycheck/dependencycheck.properties"
  end

  test do
    output = `#{libexec}/bin/dependency-check --version`.strip
    assert_match("Dependency-Check Core version #{version}", output)

    props = File.open("temp-props.properties", "w")
    props.puts "cve.startyear=2015"
    props.close

    system "#{bin}/dependency-check", "-P", "temp-props.properties", \
      "-f", "XML", "--project", "dc", "-s", libexec, "-d", testpath, "-o", testpath
    assert(File.exist?(testpath/"dependency-check-report.xml"))
  end
end
