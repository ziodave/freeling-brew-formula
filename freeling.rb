require 'formula'

# thanks to ambs for the seed of this formula, https://github.com/ambs

class Freeling < Formula
  head 'http://devel.cpl.upc.edu/freeling/svn/trunk', :using => :svn
  homepage 'http://nlp.lsi.upc.edu/freeling/'
  url 'http://devel.cpl.upc.edu/freeling/downloads/17'
  version '3.0-beta1'
  sha1 'ca788396e8d8970ad87fe5db612c65bc74c68c75'

  # depends_on 'icu4c'
  # requires boost --with-icu.
  # At the moment I think that we can not force build options
  depends_on 'boost'
  # depends_on 'libtool' => :build
  depends_on 'libtool' if MacOS::Xcode.version >= "4.3"

  def options
    [
      ['--java-api', "Build the JAVA APIs."]
    ]
  end

  def install
    opoo 'Requires boost with icu support.'
    opoo 'If the installation fails, remove boost and do a \'brew install boost --with-icu\''
    opoo 'JAVA APIs require swig 2.0.4 that you can install with the following command:'
    opoo 'brew install https://raw.github.com/mxcl/homebrew/0d8d92bfcd00f42d6af777ba8bf548cbd5502638/Library/Formula/swig.rb'

    icu4c_prefix = Formula.factory('icu4c').prefix
    libtool_prefix = Formula.factory('libtool').prefix
    boost_prefix = Formula.factory('boost').prefix

    ENV.append 'LDFLAGS', "-L#{libtool_prefix}/lib"
    # ENV.append 'LDFLAGS', "-L#{icu4c_prefix}/lib"

    ENV.append 'CPPFLAGS', "-I#{libtool_prefix}/include"
    # ENV.append 'CPPFLAGS', "-I#{icu4c_prefix}/include"

    system "aclocal"
    system "glibtoolize --force"
    system "autoconf"
    system "automake -a"
    system "autoreconf --force --install"

    system "env LDFLAGS='-L/usr/local/Cellar/libtool/2.4.2/lib -L/usr/local/Cellar/icu4c/4.8.1.1/lib -L/opt/local/lib' CPPFLAGS='-I/usr/local/Cellar/libtool/2.4.2/include -I/opt/local/include -I/usr/local/Cellar/boost/1.49.0/include -I/usr/local/Cellar/icu4c/4.8.1.1/include' ./configure --prefix=#{prefix}"
    system "make"
    system "make install"

    chdir "APIs/java"
    
  end

  # def patches
  #   { :p0 => "https://raw.github.com/gist/3295084/b0b4ff695b5bf37a021504e9f29dba94b49ebb84/000-homebrew.diff" }
  # end

  def test
    # echo 'Hello world' | analyze -f /usr/local/Cellar/freeling/HEAD/share/freeling/config/en.cfg | grep -c 'world world NN 1'
    system "echo 'Hello world' | #{bin}/analyze -f #{share}/freeling/config/en.cfg | grep -c 'world world NN 1'"
  end
end

