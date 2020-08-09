{ stdenv, fetchgit, libX11, libXinerama, libXft, patches ? [] }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "dwm";

  src = fetchgit {
    url = "https://github.com/LukeSmithXYZ/dwm";
    rev = "484720bbba3e2b175b71dba283c3a84b13e71eea";
    sha256 = "1w19zy3c9nckrh9jwj30ijv7gl0miyiw4m287n5bxmm98zly264p";
  };

  buildInputs = [ libX11 libXinerama libXft ];

  prePatch = ''sed -i "s@/usr/local@$out@" config.mk'';

  # Allow users set their own list of patches
  inherit patches;

  buildPhase = " make ";

  meta = {
    homepage = "https://github.com/LukeSmithXYZ/dwm";
    description = "Luke's build of dwm";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [pniedzwiedzinski];
    platforms = with stdenv.lib.platforms; all;
  };
}