class Patchelf < Formula
  desc "PatchELF: modify the dynamic linker and RPATH of ELF executables"
  homepage "https://nixos.org/patchelf.html"
  # tag "linuxbrew"

  url "http://nixos.org/releases/patchelf/patchelf-0.9/patchelf-0.9.tar.gz"
  sha256 "f2aa40a6148cb3b0ca807a1bf836b081793e55ec9e5540a5356d800132be7e0a"
  revision 1

  head do
    url "https://github.com/NixOS/patchelf.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-static", "Link statically"
  option "without-static-libstdc++", "Link libstdc++ dynamically"

  def install
    # Fixes error: cannot find section
    # See https://github.com/NixOS/patchelf/pull/95
    inreplace "src/patchelf.cc",
      "string sectionName = getSectionName(shdr);",
      'string sectionName = getSectionName(shdr); if (sectionName == "") continue;'
    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
      if build.with?("static") then "CXXFLAGS=-static"
      elsif build.with?("static-libstdc++") then "CXXFLAGS=-static-libgcc -static-libstdc++"
      end,
      "--disable-debug", "--disable-dependency-tracking", "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/patchelf", "--version"
  end
end
