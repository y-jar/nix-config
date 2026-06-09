{ pkgs, hostnm, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # EPIC ALIASES
    shellAliases = {
      # basic switch and clean
      nrs-ncs = "nrs && nix-cs"; # reocmended after confirming a complete stable system
      # Main nix + github aliases:
      nix-sync = "cd ~/nix-config && git pull && nrs";
      nix-save = "cd ~/nix-config && git add . && git commit -m 'Syncing changes' && git push origin master";
      # nix helper
      nht = "nh os test ~/nix-config#${hostnm}";
      nhs = "nh os switch ~/nix-config#${hostnm}";

      # Testing & Utility
      conf = "cd ~/nix-config && nvim";
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      nv = "nvim";

      # =========[Extra]
      ff = "fastfetch";
    };

    # re made my old prompt: jar->yil-jar ~ \/> (will need to add colors later)
    initContent = ''
      PROMPT='%F{#5F7CB8}J|%f'
    '';
  };
}
# Old Prompt
# PROMPT='%F{#5F7CB8}%n%F{#BA1600}->%F{#B8845F}%m %F{#B89A5F}%~
# %F{#BAB9B6}\/>'