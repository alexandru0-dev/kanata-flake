{ stdenv
, lib
, darwin
, rustPlatform
, fetchFromGitHub
, withCmd ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.6.1";


  src = fetchFromGitHub {
    owner = "jtroo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Kuxy6lGzImYYujuJwZZdfuu3X7/PJNOJefeZ0hVJaAA=";
  };

  cargoPatches = [ ./time.patch ]; # needed for rust 1.18.0+

  cargoHash =
    if stdenv.isLinux
    then "sha256-R2lHg+I8Sry3/n8vTfPpDysKCKMDUvxyMKRhEQKDqS0=" # TODO: fix sha
    else "sha256-ERlo5Lvj5xn13DY3hocoXZq8yWnglIpaMNVBIYjAoTI=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.IOKit ];

  buildFeatures = lib.optional withCmd "cmd";

  postPatch = lib.optional stdenv.isDarwin ''
    pushd $cargoDepsCopy/karabiner-driverkit
    oldHash=$(sha256sum build.rs | cut -d " " -f 1)
    patch -p2 -i ${./dext_only.patch}
    substituteInPlace .cargo-checksum.json \
      --replace-fail $oldHash $(sha256sum build.rs | cut -d " " -f 1)
    popd
  '';

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
    #broken = stdenv.hostPlatform.isx86;
  };
}
