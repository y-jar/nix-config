# Guide to Customizing Pipewire
*as per my understanding*

### Intro to an Audio Block

In this is a simple block within an audio block for a pipewire setup. Here is a basic run down on how to make and manage audio channels.
```nix
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
```

this is placed within this block
```nix
extraConfig.pipewire = {
  "super-epic-unique-name-of-json" = {
    "context.modules" = [
      # Audio blocks go here like the discord block
      # as it is an array, just add more {} to make more audio blocks
    ];
  };
};
```


### `libpipewire-module-loopback` the loopback module..

I think of a loopback module as a virtual audio cable. Every loopback has two ends:
1. `capture.props`: (The Input/Jack): Where audio goes in.
2. `playback.props`: (The Output/Plug): Where audio comes out.

---


### The Body of an Audio block
inside an audio block ive seen that there are always these things:
1. `"name" = "libpipewire-module-loopback";`: Tells pipewire to load the loopback module
2. `"args" = { ... };`: These are the specific instructions for building this exact loopback cable

### The Body Of an Args Block
- `"node.description" = "Discord Monitor";`: Serves as human readable name for applications like pavucontrol or anything else.
- `"capture.props" = { ... };`: The block the sets up Input for the Loopback
- `"playback.props" = { ... };`: after the input, where ever this section is attached, that is where the output goes, hence 'output'.

```nix
"capture.props" = {
  "node.name" = "discord-capture";
  "node.passive" = true;
  "media.class" = "Audio/Sink";
  "audio.position" = ["FL" "FR"];
};
```
- node.name = "discord-capture": The internal, unique system ID for this node.
- media.class = "Audio/Sink": This is the magic trick. By labeling the capture side as a "Sink" (a speaker), applications like Discord will see it as a valid output device. You can tell Discord to play its audio here.
- audio.position = ["FL" "FR"]: Forces the channel to be standard two-channel stereo (Front-Left, Front-Right).
- node.passive = true: This is a great optimization. It tells PipeWire, "If no audio is playing through this node, put it to sleep." This saves CPU cycles and battery life.

```nix
"playback.props" = {
  "node.description" = "Discord";
  "node.name" = "discord-playback";
  "node.passive" = true;
  "audio.position" = ["FL" "FR"];
  "stream.dont-remix" = true;
  "target.object" = "headphone-capture";
};
```
- node.description = "Discord": The clean name you will see in your volume mixer.
- node.name = "discord-playback": The internal ID for the output node.
- stream.dont-remix = true: This prevents PipeWire from trying to "guess" how to map audio. If a game outputs 5.1 surround sound into this stereo cable, dont-remix stops PipeWire from trying to mash all 6 channels into 2, which often causes distortion.
- target.object = "headphone-capture": This is the most important line. Instead of forcing you to open Helvum and manually draw a wire from Discord to your headphones every time you boot up, this automatically hard-wires the Discord output directly into the node named headphone-capture.
- for stuff within and i want them to have more of an **identity** ill need this:
  - `"media.class" = "Audio/Sink";   # Act like a Virtual Speaker`
  - `"media.class" = "Audio/Source"; # Act like a Virtual Microphone`
  - > Note: When media.class is *explicitly* declared: It tells the system system-wide framework (like pavucontrol, OBS, or Steam) to display this node as a selectable physical device.
  - > ---- When media.class is *omitted*: The node remains hidden from standard software menus as a selectable device. It exists purely as a raw routing node meant to be linked behind the scenes inside graph engines like qpwgraph.
  - > -Explained By a Model

### The Master Bus (Headphones & Microphone)
the Headphones and Microphone blocks. These are the "Master Buses" acording to [ @TomShreck @ https://github.com/UndefProphet/.nixos/blob/main/modules/nixos/audio.nix ]

Instead of routing directly to a physical hardware ID (like alsa_output.pci-0000_00_1f.3...), they set up these intermediate master channels:

1. The Apps play into their virtual cables (e.g., discord-capture).
2. The virtual cables push audio to their playbacks (e.g., discord-playback).
3. The playbacks route into the Headphone Bus (target.object = "headphone-capture").
4. Because the Headphone block has no target.object defined in its playback, PipeWire uses its default behavior: it automatically routes it to your default physical hardware speakers/headphones.