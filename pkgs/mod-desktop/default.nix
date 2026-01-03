{ lib
, stdenv
, fetchurl
, makeWrapper
, autoPatchelfHook
, imagemagick
, libsForQt5
, # dependencies
  alsa-lib
, dbus
, desktop-file-utils
, pipewire
, qt5
, shared-mime-info
,
}:

stdenv.mkDerivation rec {
  pname = "mod-desktop";
  version = "0.0.12";

  src = fetchurl {
    url = "https://github.com/moddevices/mod-desktop/releases/download/${version}/mod-desktop-${version}-linux-x86_64.tar.xz";
    sha256 = "0365qx49hi62n4wkjxw34wy5w9gi2cph3dp9gr9fzma18q4z5yni";
  };

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
    desktop-file-utils
    imagemagick
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    dbus
    pipewire
    pipewire.jack
    qt5.qtbase
    shared-mime-info
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/pkg
    cp -a * $out/pkg

    mkdir $out/bin
    makeWrapper $out/pkg/mod-desktop.run $out/bin/${pname} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --set QT_PLUGIN_PATH "${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}" \
      --set QT_QPA_PLATFORM_PLUGIN_PATH "${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}/platforms"

    # generate icons
    for size in 16 24 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      magick mod-desktop/html/img/favicon/favicon.png -resize ''${size}x''${size} \
        $out/share/icons/hicolor/''${size}x''${size}/apps/${pname}.png
    done

    mkdir -p $out/share/applications
    sed -i "s,^Exec=.*\$,Exec=$out/bin/mod-desktop," mod-desktop.desktop
    sed -i "s/^Icon=.*/Icon=mod-desktop/" mod-desktop.desktop
    desktop-file-install --dir=$out/share/applications mod-desktop.desktop

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open-source modular audio tools for musicians, tinkerers & tone hackers";
    homepage = "https://mod.audio/desktop/";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.yourname ];
    platforms = platforms.linux;
  };
}
