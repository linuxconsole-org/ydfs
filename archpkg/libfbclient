# Maintainer: Felix Yan <felixonmars@archlinux.org>
# Contributor: Carlier Laurent <lordheavym@gmail.com>
# Contributor: Douglas Soares de Andrade <dsa@aur.archlinux.org>

pkgname=libfbclient
pkgver=5.0.1.1469
pkgrel=1
pkgdesc="Client library for Firebird"
arch=('x86_64')
url="https://www.firebirdsql.org/"
license=('custom')
depends=('gcc-libs' 'libtommath')
makedepends=('editline' 'libtomcrypt' 'unzip' 'cmake')
source=(https://github.com/FirebirdSQL/firebird/releases/download/v${pkgver%.*}/Firebird-$pkgver-0-source.tar.xz
        LICENSE)
sha512sums=('8738a2321e42412f0c6d7ec53cb9a65a4f23e788058fb713f9958b4915f738bad88040f49daafad5679b505c39296b0c9d5bb97bb8c8c0af8995399f726fe93d'
            '1e4c24f60d2cdc1a89b52b45f778ed264ae14428a940b0509ca5c50182aed6149b7a6a546e7d08b0f264bafde81a210abe20db204c20db596f5fc2ec205ac37e')
options=(!lto) # Segfaults with LTO

prepare() {
  # Ensure system libs are used
  rm -r Firebird-$pkgver-0-source/extern/{editline,libtommath,libtomcrypt,zlib}
}

build() {
  cd Firebird-$pkgver-0-source

  ./configure --prefix=/usr \
    --without-fbsbin --without-fbconf --without-fbdoc --without-fbsample \
    --without-fbsample-db --without-fbintl --without-fbmisc --without-fbhelp \
    --without-fbsecure-db --with-fbmsg=/usr/share/firebird --without-fblog \
    --without-fbglock --without-fbplugins --without-fbtzdata --with-system-editline

  make
}

package() {
  cd Firebird-$pkgver-0-source

  mkdir -p "$pkgdir"/usr/{bin,share/{firebird,licenses/$pkgname}}

  cp -R gen/Release/firebird/{lib,include} "$pkgdir"/usr
  rm -f "$pkgdir"/usr/lib/{libdecFloat.a,libedit.a,libre2.a}

  install -m644 gen/Release/firebird/*.msg "$pkgdir"/usr/share/firebird
  install -m755 gen/Release/firebird/bin/fb_config "$pkgdir"/usr/bin
  install -m644 "$srcdir"/LICENSE "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
}
