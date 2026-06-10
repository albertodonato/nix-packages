{
  lib,
  stdenv,
  fetchgit,
  cairo,
  libX11,
  libjack2 ? null,
  libsndfile,
  lv2,
  makeWrapper,
  ncurses,
  pkg-config,
  desktop-file-utils,
  portaudio ? null,
}:

stdenv.mkDerivation rec {
  pname = "neuralrack";
  version = "0.3.3";

  src = fetchgit {
    url = "https://github.com/brummer10/NeuralRack.git";
    rev = "v${version}";
    hash = "sha256-N1U3ekTAZqu+aQE/WIL3RHxDQGSxDecFKak5KScioCY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    desktop-file-utils
    makeWrapper
    ncurses
    pkg-config
  ];

  buildInputs = [
    cairo.dev
    libX11
    libsndfile
    lv2
  ]
  ++ lib.optionals (libjack2 != null) [ libjack2 ]
  ++ lib.optionals (portaudio != null) [ portaudio ];

  hardeningDisable = [ "fortify" ];

  env.NIX_CFLAGS_COMPILE = "-I${cairo.dev}/include/cairo -fno-lto";

  buildPhase = ''
    make standalone PREFIX=$out
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp NeuralRack/Neuralrack $out/bin

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp NeuralRack/standalone/NeuralRack.svg $out/share/icons/hicolor/scalable/apps/

    mkdir -p $out/share/applications
    desktop-file-install \
      --set-key=Version --set-value=1.0 \
      --dir=$out/share/applications \
      NeuralRack/standalone/NeuralRack.desktop
  '';

  meta = with lib; {
    description = "Neural Model and Impulse Response File loader";
    homepage = "https://github.com/brummer10/NeuralRack";
    license = licenses.bsd3;
    maintainers = [ maintainers.yourname ];
    platforms = platforms.linux;
    mainProgram = "Neuralrack";
  };
}
