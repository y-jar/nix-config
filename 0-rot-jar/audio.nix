# credit to @TomShreck @ https://github.com/UndefProphet/.nixos/blob/main/modules/nixos/audio.nix
{
  flake.modules.nixos.audio = {pkgs, ...}: {
    services.pulseaudio.enable = false;
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    security.rtkit.enable = true;
    services.playerctld.enable = true; # Enable to manage audio from audio sources.

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # Audio configuration for seperating audio sources.
      # Note: node.name must be unique otherwise programs like obs is connecting to first instance of name.
      # pw-loopback --name='test' --capture-props='node.description="test monitor" media.class=Audio/Sink node.name=test-capture audio.position=[FL FR]' --playback-props='node.description="test" node.name=test-playback audio.position=[FL FR] target.object=headphone-capture'
      extraConfig.pipewire = {
        "audio-seperation-setup" = {
          # "context.properties" = {
          #   "default.clock.allowed-rates" = [ 48000 ];
          #   "default.clock.min-quantum"   = 32;
          #   "default.clock.max-quantum"   = 2048;
          # };

          "context.modules" = [
            # Remap the default microphone
            {
              "name" = "libpipewire-module-loopback";
              "args" = {
                "name" = "Microphone";
                "node.description" = "Microphone";

                # Autoconnect to default input device
                "capture.props" = {
                  "node.name" = "microphone-capture";
                  "node.passive" = true;
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                };
                "playback.props" = {
                  "node.name" = "microphone-playback";
                  "media.class" = "Audio/Source";
                  "audio.position" = [ "FL" "FR" ];
                  "stream.dont-remix" = true;
                  "node.passive" = true;
                };
              };
            }

            # Remap the default headphone
            {
              "name" = "libpipewire-module-loopback";
              "args" = {
                "name" = "Headpones";
                "node.description" = "Headphone";
                "capture.props" = {
                  "node.name" = "headphone-capture";
                  "node.passive" = true;
                  "media.class" = "Audio/Sink";
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                };

                # Auto connect to default output device
                "playback.props" = {
                  "node.name" = "headphone-playback";
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                  "stream.dont-remix" = true;
                  "node.passive" = true;
                };
              };
            }

            # Discord
            {
              "name" = "libpipewire-module-loopback";
              "args" = {
                "node.description" = "Discord Monitor";
                "capture.props" = {
                  "node.name" = "discord-capture";
                  "node.passive" = true;
                  "media.class" = "Audio/Sink";
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                };
                "playback.props" = {
                  "node.description" = "Discord";
                  "node.name" = "discord-playback";
                  "node.passive" = true;
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                  "stream.dont-remix" = true;
                  "target.object" = "headphone-capture";
                };
              };
            }

            # Music
            {
              "name" = "libpipewire-module-loopback";
              "args" = {
                "node.description" = "Music Monitor";
                "capture.props" = {
                  "node.name" = "music-capture";
                  "node.passive" = true;
                  "media.class" = "Audio/Sink";
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                };
                "playback.props" = {
                  "node.description" = "Music";
                  "node.name" = "music-playback";
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                  "stream.dont-remix" = true;
                  "node.passive" = true;
                  "target.object" = "headphone-capture";
                };
              };
            }

            # Games
            {
              "name" = "libpipewire-module-loopback";
              "args" = {
                "node.description" = "Games Monitor";
                "capture.props" = {
                  "node.name" = "games-capture";
                  "node.passive" = true;
                  "media.class" = "Audio/Sink";
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                };
                "playback.props" = {
                  "node.description" = "Games";
                  "node.name" = "games-playback";
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                  "stream.dont-remix" = true;
                  "node.passive" = true;
                  "target.object" = "headphone-capture";
                };
              };
            }

            # Browser
            {
              "name" = "libpipewire-module-loopback";
              "args" = {
                "node.description" = "Browser Monitor";
                "capture.props" = {
                  "node.name" = "browser-capture";
                  "node.passive" = true;
                  "media.class" = "Audio/Sink";
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                };
                "playback.props" = {
                  "node.description" = "Browser";
                  "node.name" = "browser-playback";
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                  "stream.dont-remix" = true;
                  "node.passive" = true;
                  "target.object" = "headphone-capture";
                };
              };
            }

            # VoIP
            {
              "name" = "libpipewire-module-loopback";
              "args" = {
                "node.description" = "VoIP Monitor";
                "capture.props" = {
                  "node.name" = "voip-capture";
                  "node.passive" = true;
                  "media.class" = "Audio/Sink";
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                };
                "playback.props" = {
                  "node.description" = "VoIP";
                  "node.name" = "voip-playback";
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                  "stream.dont-remix" = true;
                  "node.passive" = true;
                  "target.object" = "headphone-capture";
                };
              };
            }
          ];
        };
      };

      wireplumber = {
        enable = true;

        extraConfig = {
          # "log-level-debug" = {
          #   "context.properties" = {
          #     # Output Debug log messages as opposed to only the default level (Notice)
          #     "log.level" = "D";
          #   };
          # };

          # "wireplumber.profiles" = {
          #   main = { "custom.98-spdif-nodriver" = "required"; };
          # };

          # # Keep SPDIF input active, but don't let it become the driver
          # "98-spdif-nodriver" = {
          #   "monitor.alsa.rules" = [{
          #     matches = [{
          #       "node.name" = "alsa_input.*";
          #       "media.class" = "Audio/Source";
          #       "node.description" = "CA0110*";
          #     }];

          #     actions = {
          #       # "node.want-driver" = false;
          #       "node.pause-on-idle" = true;
          #       # "session.suspend-timeout-seconds" = 0;
          #     };
          #   }];
          # };
        };

        # extraScripts = {

        #   "98-spdif.lua" = ''
        #     -- Keep SPDIF input active, but don't let it become the driver
        #     rule = {
        #       matches = {
        #         {
        #           { "node.name", "matches", "alsa_input.*" },
        #           { "media.class", "equals", "Audio/Source" },
        #           { "node.description", "matches", ".*SPDIF.*" },
        #         },
        #       },
        #       apply_properties = {
        #         ["node.want-driver"] = false,
        #         ["node.pause-on-idle"] = false,
        #       }
        #     }

        #     table.insert(alsa_monitor.rules, rule)
        #   '';

        # };
      };
    };

    # # FOR SCREAM
    # networking.firewall = {
    #   allowedUDPPorts = [ 4010 ];
    # };

    hm = {
      # User packages
      home.packages = with pkgs; [
        qpwgraph

        # carla
        # yabridge
        # yabridgectl
        #
        # lsp-plugins
        # deepfilternet

        pavucontrol
        qjackctl
        # jacktrip
        pulseaudio
        # raysession

        # scream

        # (pkgs.extend (final: prev: {
        #   raysession = prev.raysession.overrideAttrs (old: rec {
        #     version = "0.14.4";
        #     src = fetchurl {
        #       url =
        #         "https://github.com/Houston4444/RaySession/releases/download/v${version}/RaySession-${version}-source.tar.gz";
        #       sha256 = "sha256-cr9kqZdqY6Wq+RkzwYxNrb/PLFREKUgWeVNILVUkc7A=";
        #     };
        #   });
        # })).raysession

        # (pkgs.extend (final: prev: {
        #   carla = prev.carla.overrideAttrs (old: {
        #     buildInputs = old.buildInputs ++ [
        #       # wine
        #       # wine64
        #       wineWowPackages.waylandFull
        #       ];
        #   });
        # })).carla

        # (pkgs.extend (final: prev: {
        #   airwave = prev.airwave.overrideAttrs (old: {
        #     wine-wow64 = wine.override {
        #       wineRelease = "unstable";
        #       wineBuild = "wineWow";
        #     };

        #   });
        # })).airwave
      ];
    };
  };
}