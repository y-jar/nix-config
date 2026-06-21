{ lib, config, ... }:
let
  cfg = config.sysSettings.audio.addon;
in
{
  # options for the audio addon
  options = {
    sysSettings.audio.addon.enable = lib.mkEnableOption "My audio setup to enable to disable";
  }; # End of Options

  # configuration for the audio addon
  config = lib.mkIf cfg.enable {
    # This is my audio channel Setup, I will try to keep this well Documented so i can share this like @tomShreak did for me
    services.pipewire = {
      extraConfig.pipewire = {
        # I think this is an arbituary name i can use so it can be plased into json
        # It is sorted alphanumarically and the lower is not recomended.
        "97-jars" = {
          # an array of the instructions for all the sinks / inputs
          "context.modules" = [
            # TEMPLATE
            # {
            #   # base stats
            #   "name" = "libpipewire-module-loopback"; # mod name [when named something specific, it will be called to that module and functions as what it is..]
            #   "args" = {
            #     # Stats & actual settings and configs go in here
            #     "name" = "TEMPLATE_NAME_ID"; # ID of the whole audio channel
            #     "node.description" = "TEMPLATE_AUDIO_DESCRIPTION"; # name of the audio module
            #     # serves as an input
            #     "capture.props" = {
            #       "node.name" = "TEMPLATE_CAP"; # name of the node of the module
            #       "audio.position" = ["FL" "FR"]; # sets the routing options
            #       "node.passive" = true; # states that the node is considered background unless acted apon
            #       # "media.class" = "Audio/Sink"; # functions as sink for audio that is to be sent over to playback
            #       # "media.class" = "Audio/Source"; # this will now function as an audio source / mic publicly
            #     };
            #     # serves as an Output [most apps should attach to this]
            #     "playback.props" = {
            #       "node.name" = "TEMPLATE_OUT"; # name of the node of the module
            #       "audio.position" = ["FL" "FR"]; # sets the routing options
            #       "stream.dont-remix" = true; # prevents audio remixing when channels want to input as diffrent formats
            #       "node.passive" = true; # states that the node is considered background unless acted apon
            #       # "target.object" = "RECIVING_TEMPLATE_CAP"; # audio routes
            #       # "media.class" = "Audio/Source"; # this will now function as an audio source / mic publicly
            #       # "media.class" = "Audio/Sink"; # functions as sink for audio that is to be sent over to playback
            #     };
            #   };
            # } # end of TEMPLATE mod
            #
            # `````````````````````````````````````````````````````````````
            # =====================AUDIO CHANNELS

            # MIC setup
            {
              # base Stats
              "name" = "libpipewire-module-loopback";
              # actual settings and configs go in here
              "args" = {
                # stats
                "name" = "Microphone"; # ID of the whole audio channel
                "node.description" = "Microphone"; # name of the audio module
                # serves as an input (should connect to the default mic)
                "capture.props" = {
                  "node.name" = "mic-cap"; # name of the node of the module
                  "node.passive" = false; # states that the node is considered background unless acted apon
                  "audio.position" = [
                    "FL"
                    "FR"
                  ]; # sets the routing options
                };
                # serves as an Output
                "playback.props" = {
                  "node.name" = "mic-out";
                  "media.class" = "Audio/Source"; # this will now function as an audio source / mic publicly
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                  "stream.dont-remix" = true;
                  "node.passive" = false;
                };
              };
            } # End of mic

            # OUTPUT / HEADPHONE / audio-jar setup
            {
              # THIS SERVES AS THE AUDIO HUB THAT THE BELOW CONNECT TO
              # base stats
              "name" = "libpipewire-module-loopback"; # mod name [when named something specific, it will be called to that module and functions as what it is..]
              "args" = {
                # Stats & actual settings and configs go in here
                "name" = "jar-audio"; # ID of the whole audio channel
                "node.description" = "jar-audio"; # name of the audio module
                # serves as an input
                "capture.props" = {
                  "node.name" = "jar-cap"; # name of the node of the module
                  "audio.position" = [
                    "FL"
                    "FR"
                  ]; # sets the routing options
                  "node.passive" = true; # states that the node is considered background unless acted apon
                  "media.class" = "Audio/Sink"; # functions as sink for audio that is to be sent over to playback
                };
                # serves as an Output [most apps should attach to this]
                "playback.props" = {
                  "node.name" = "jar-out"; # name of the node of the module
                  "audio.position" = [
                    "FL"
                    "FR"
                  ]; # sets the routing options
                  "stream.dont-remix" = true; # prevents audio remixing when channels want to input as diffrent formats
                  "node.passive" = true; # states that the node is considered background unless acted apon
                  # "media.class" = "Audio/Source"; # this will now function as an audio source / mic publicly
                  # "target.object" = "RECIVING_TEMPLATE_CAP"; # audio routes
                };
              };
            } # end of AUDIO-JAR mod

            # ===============================================================
            # =============================================================
            # SECONDARY SINK CHANNELS, no playback output classes
            # GAME setup
            {
              # base stats
              "name" = "libpipewire-module-loopback"; # mod name [when named something specific, it will be called to that module and functions as what it is..]
              "args" = {
                # Stats & actual settings and configs go in here
                "name" = "game-audio"; # ID of the whole audio channel
                "node.description" = "game-audio"; # name of the audio module
                # serves as an input
                "capture.props" = {
                  "node.name" = "game-cap"; # name of the node of the module
                  "audio.position" = [
                    "FL"
                    "FR"
                  ]; # sets the routing options
                  "node.passive" = true; # states that the node is considered background unless acted apon
                  "media.class" = "Audio/Sink"; # functions as sink for audio that is to be sent over to playback
                };
                # serves as an Output [most apps should attach to this]
                "playback.props" = {
                  "node.name" = "game-out"; # name of the node of the module
                  "audio.position" = [
                    "FL"
                    "FR"
                  ]; # sets the routing options
                  "stream.dont-remix" = true; # prevents audio remixing when channels want to input as diffrent formats
                  "node.passive" = true; # states that the node is considered background unless acted apon
                  # "media.class" = "Audio/Source"; # this will now function as an audio source / mic publicly
                  "target.object" = "jar-cap"; # audio routes
                };
              };
            } # end of GAME mod

            # BROWSER setup
            {
              # base stats
              "name" = "libpipewire-module-loopback"; # mod name [when named something specific, it will be called to that module and functions as what it is..]
              "args" = {
                # Stats & actual settings and configs go in here
                "name" = "browser-audio"; # ID of the whole audio channel
                "node.description" = "browser-audio"; # name of the audio module
                # serves as an input
                "capture.props" = {
                  "node.name" = "browser-cap"; # name of the node of the module
                  "audio.position" = [
                    "FL"
                    "FR"
                  ]; # sets the routing options
                  "node.passive" = true; # states that the node is considered background unless acted apon
                  "media.class" = "Audio/Sink"; # functions as sink for audio that is to be sent over to playback
                };
                # serves as an Output [most apps should attach to this]
                "playback.props" = {
                  "node.name" = "browser-out"; # name of the node of the module
                  "audio.position" = [
                    "FL"
                    "FR"
                  ]; # sets the routing options
                  "stream.dont-remix" = true; # prevents audio remixing when channels want to input as diffrent formats
                  "node.passive" = true; # states that the node is considered background unless acted apon
                  "target.object" = "jar-cap"; # audio routes
                  # "media.class" = "Audio/Source"; # this will now function as an audio source / mic publicly
                };
              };
            } # end of BROWSER mod

            # MUSIC setup
            {
              # base stats
              "name" = "libpipewire-module-loopback"; # mod name [when named something specific, it will be called to that module and functions as what it is..]
              "args" = {
                # Stats & actual settings and configs go in here
                "name" = "music-audio"; # ID of the whole audio channel
                "node.description" = "music-audio"; # name of the audio module
                # serves as an input
                "capture.props" = {
                  "node.name" = "music-cap"; # name of the node of the module
                  "audio.position" = [
                    "FL"
                    "FR"
                  ]; # sets the routing options
                  "node.passive" = true; # states that the node is considered background unless acted apon
                  "media.class" = "Audio/Sink"; # functions as sink for audio that is to be sent over to playback
                };
                # serves as an Output [most apps should attach to this]
                "playback.props" = {
                  "node.name" = "music-out"; # name of the node of the module
                  "audio.position" = [
                    "FL"
                    "FR"
                  ]; # sets the routing options
                  "stream.dont-remix" = true; # prevents audio remixing when channels want to input as diffrent formats
                  "node.passive" = true; # states that the node is considered background unless acted apon
                  "target.object" = "jar-cap"; # audio routes
                  # "media.class" = "Audio/Source"; # this will now function as an audio source / mic publicly
                };
              };
            } # end of MUSIC mod

            # CHAT setup
            {
              # base stats
              "name" = "libpipewire-module-loopback"; # mod name [when named something specific, it will be called to that module and functions as what it is..]
              "args" = {
                # Stats & actual settings and configs go in here
                "name" = "chat-audio"; # ID of the whole audio channel
                "node.description" = "chat-audio"; # name of the audio module
                # serves as an input
                "capture.props" = {
                  "node.name" = "chat-cap"; # name of the node of the module
                  "audio.position" = [
                    "FL"
                    "FR"
                  ]; # sets the routing options
                  "node.passive" = true; # states that the node is considered background unless acted apon
                  "media.class" = "Audio/Sink"; # functions as sink for audio that is to be sent over to playback
                };
                # serves as an Output [most apps should attach to this]
                "playback.props" = {
                  "node.name" = "chat-out"; # name of the node of the module
                  "audio.position" = [
                    "FL"
                    "FR"
                  ]; # sets the routing options
                  "stream.dont-remix" = true; # prevents audio remixing when channels want to input as diffrent formats
                  "node.passive" = true; # states that the node is considered background unless acted apon
                  "target.object" = "jar-cap"; # audio routes
                  # "media.class" = "Audio/Source"; # this will now function as an audio source / mic publicly
                };
              };
            } # end of CHAT mod
          ]; # End of context.modules array
        }; # End of 97-jars block
        "99-quantum" = {
          "context.properties" = {
            "default.clock.quantum" = 1024; # 1024 or 2048
            "default.clock.min-quantum" = 256;
            "default.clock.rate" = 48000;
            "default.clock.allowed-rates" = [ 48000 ];
          }; # End of context.properties
        }; # End of 99-quantum block
      }; # End of extraConfig block
    }; # End of pipewire block
  }; # End of Config
}
