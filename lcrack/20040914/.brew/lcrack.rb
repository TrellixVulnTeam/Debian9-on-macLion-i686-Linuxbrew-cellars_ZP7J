class Lcrack < Formula
  desc "Generic password cracker"
  homepage "https://packages.debian.org/sid/lcrack"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/l/lcrack/lcrack_20040914.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/l/lcrack/lcrack_20040914.orig.tar.gz"
  version "20040914"
  sha256 "63fe93dfeae92677007f1e1022841d25086b92d29ad66435ab3a80a0705776fe"

  def install
    system "./configure"
    system "make"
    bin.install "lcrack"

    # This prevents installing slightly generic names (regex)
    # and also mimics Debian's installation of lcrack.
    %w[mktbl mkword regex].each do |prog|
      bin.install prog => "lcrack_#{prog}"
    end
  end

  test do
    (testpath/"secrets.txt").write "root:5ebe2294ecd0e0f08eab7690d2a6ee69:SECRET"
    (testpath/"dict.txt").write "secret"

    output = pipe_output("#{bin}/lcrack -m md5 -d dict.txt -xf+ -s a-z -l 1-8 secrets.txt 2>&1")
    assert_match "Found: 1", output
  end
end
