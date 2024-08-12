{ stdenv
, lib
, darwin
, rustPlatform
, fetchFromGitHub
, withCmd ? false
, withKarabinerKext ? false
}:

lib.throwIf (!stdenv.isDarwin && withKarabinerKext) "Karabiner Kext is only compatible with Darwin systems"

rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Kuxy6lGzImYYujuJwZZdfuu3X7/PJNOJefeZ0hVJaAA=";
  };

  patches = [ ./lock.patch ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "karabiner-driverkit-0.1.3" = "sha256-HAIWkO6NX8xZDda/1BjCUQRBSIVyxK0hMvM2+Ctkqvs=";
    };
  };

  cargoHash =
    if stdenv.isLinux
    then "sha256-R2lHg+I8Sry3/n8vTfPpDysKCKMDUvxyMKRhEQKDqS0="
    else ""; # for darwin is already set

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.IOKit ];

  buildNoDefaultFeatures = true;

  buildFeatures = ["tcp_server"] ++
    (if withKarabinerKext then ["macos_kext"] else ["macos_dext"]) ++
    lib.optional withCmd ["cmd"];

  postInstall = ''
    install -Dm 444 assets/kanata-icon.svg $out/share/icons/hicolor/scalable/apps/kanata.svg
  '';

  meta = with lib; {
    description = "Tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ bmanuel linj ];
    platforms = platforms.unix;
    mainProgram = "kanata";
  };
}

