{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # EPIC ALIASES
    shellAliases = {
    	# The Big Three for Configs in nix
    	nrs = "sudo nixos-rebuild switch --flake ~/nix-config#yil-jar"; # actual building
        nrt = "sudo nixos-rebuild test --flake ~/nix-config#yil-jar"; # testing
    	nfu = "nix flake update ~/nix-config";
    	nclean = "sudo nix-collect-garbage -d";

    	# Testing & Utility
  	conf = "cd ~/nix-config && nvim";
  	ls = "ls --color=auto";
  	grep = "grep --color=auto";
	nv = "nvim";
    };

    # re made my old prompt: jar->yil-jar ~ \/> (will need to add colors later)
    initContent = ''
    	fastfetch
	PROMPT='%F{#5F7CB8}%n%F{#BA1600}->%F{#B8845F}%m %F{#B89A5F}%~
%F{#BAB9B6}\/>'
    '';
  };
}
