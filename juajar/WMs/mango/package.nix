# goal: build mango 0.18.2 with in-tree patches: screen-zoom, switcher-warp.
# inputs.mangowm pins the upstream rev (flake.lock keeps the exact revision),
# scenefx MUST come from mango's own lock (inputs.mangowm.inputs.scenefx):
# scenefx is ABI-tied to the wlroots tree the modules were built against, and
# upstream mango builds against nixpkgs wlroots_0_20.
{
  inputs,
  lib,
  libX11,
  libinput,
  libxcb,
  libdrm,
  libxkbcommon,
  pcre2,
  pango,
  cjson,
  pixman,
  pkg-config,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxcb-wm,
  xwayland,
  meson,
  ninja,
  wlroots_0_20,
  libGL,
  enableXWayland ? true,
  debug ? false,
}:
let
  scenefx = (inputs.mangowm.inputs.scenefx.packages.${stdenv.hostPlatform.system}).default;
  # wlroots with the ext capture privacy hook (juajar/WMs/mango/patches):
  # a compositor callback swaps each capture source frame's buffer for a
  # privacy-filtered one; ABI-compatible with upstream 0.20 (field baked
  # into struct wlr_output, see patches/README.md).
  wlrootsPrivacy = wlroots_0_20.overrideAttrs (o: {
    patches = (o.patches or [ ]) ++ [ ./patches/wlroots-capture-privacy.patch ];
  });
  src = stdenv.mkDerivation {
    name = "mango-0.18.2-zoom-source";
    src = inputs.mangowm.outPath; # pinned 0.18.2 rev (flake.lock)
    patches = [
      ./patches/screen-zoom.patch
      ./patches/switcher-warp.patch
      ./patches/stream-privacy.patch
    ];
    installPhase = ''
      runHook preInstall
      cp -a . $out
      runHook postInstall
    '';
  };
in
stdenv.mkDerivation {
  pname = "mango";
  version = "0.18.2-zoom";

  inherit src;

  mesonFlags = [
    (lib.mesonEnable "xwayland" enableXWayland)
    (lib.mesonBool "asan" debug)
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libinput
    libxcb
    libxkbcommon
    pcre2
    pango
    cjson
    pixman
    wayland
    wayland-protocols
    wlrootsPrivacy
    scenefx
    libGL
    libdrm
  ]
  ++ lib.optionals enableXWayland [
    libX11
    libxcb-wm
    xwayland
  ];

  passthru = {
    providedSessions = [ "mango" ];
  };

  meta = {
    mainProgram = "mango";
    description = "mango (mangowm) 0.18.2, patched with a cursor-following live screen zoom";
    homepage = "https://github.com/mangowm/mango";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
