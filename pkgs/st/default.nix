{ stdenv, fetchurl, pkgconfig, writeText, libX11, ncurses, libXft }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "st";

  src = fetchgit {
    url = "https://github.com/LukeSmithXYZ/st";
    rev = "de6fd85eeb544548ed5ad23a639eedd6af510036";
  };

  nativeBuildInputs = [ pkgconfig ncurses ];
  buildInputs = [ libX11 libXft ];

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
  '';

  meta = {
    homepage = "https://st.suckless.org/";
    description = "Simple Terminal for X from Suckless.org Community";
    license = licenses.mit;
    maintainers = with maintainers; [ pniedzwiedzinski ];
    platforms = platforms.linux;
  };
}
