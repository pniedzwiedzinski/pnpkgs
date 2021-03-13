{ stdenv, buildEnv, makeWrapper, makeDesktopItem, callPackage,
newsboat, libnotify, entr, mpv, sxiv }:
with stdenv.lib;

let
  pname = "larbs-news";
  version = "1.0";
  voidrice = callPackage ../voidrice.nix { };
  task-spooler = callPackage ../task-spooler { };
  newsboatConfig = "${voidrice}/.config/newsboat/config";

  newsboatWrapped = stdenv.mkDerivation {
    inherit pname version;
    unpackPhase = "true";

    buildInputs = [ makeWrapper ];

    installPhase = ''
      makeWrapper ${newsboat}/bin/newsboat $out/bin/newsboat \
      --add-flags "-C ${newsboatConfig}"
    '';

  };

  desktopItem = makeDesktopItem {
    name = pname;
    genericName = "RSS Reader";
    comment = "Newsboat configuration by Luke Smith";
    exec = "${newsboatWrapped}/bin/newsboat";
    # icon =
    desktopName = pname;
    mimeType = "application/rss+xml";
    categories = "Network";
    terminal = "true";
  };

in
  buildEnv {
    name = pname;

    paths = [
      newsboatWrapped
      task-spooler
      libnotify
      entr
      mpv
      sxiv
    ];

    postBuild = ''
      cp ${voidrice}/.local/bin/statusbar/sb-news $out/bin/sb-news
      cp ${voidrice}/.local/bin/cron/newsup $out/bin/newsup
      cp ${voidrice}/.local/bin/qndl $out/bin/qndl
      cp ${voidrice}/.local/bin/queueandnotify $out/bin/queueandnotify
      cp ${voidrice}/.local/bin/podentr $out/bin/podentr
      cp ${voidrice}/.local/bin/linkhandler $out/bin/linkhandler
      cp -r ${desktopItem}/share/applications $out/share/applications

      sed -i 's:/usr/bin/::g' $out/bin/newsup
    '';

    meta = {
      homepage = "https://github.com/LukeSmithXYZ/voidrice";
      description = "Newsboat RSS reader with vim bindings";
      license = licenses.gpl3;
      platforms = [ "x86_64-linux" "x86_64-darwin" ];
    };
  }
