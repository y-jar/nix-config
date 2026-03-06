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
	# Heavy clean up and optimize
	nix-c = "sudo nix-collect-garbage -d && nix-collect-garbage -d && nix-store --optimize";
	nix-cs = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +5 && nix-env --delete-generations +5 && nix-collect-garbage && nix-store --optimize";
	# basic switch and clean
	nrs-ncs = "nrs && nix-cs"; # reocmended after confirming a complete stable system

	# Main nix + github aliases:
	nix-sync = "cd ~/nix-config && git pull && nrs";
	nix-save = "cd ~/nix-config && git add . && git commit -m 'Syncing changes' && git push origin main";

	# creates the dirs i use from a gist in github
	dir-init = "curl -sL https://gist.githubusercontent.com/y-jar/263b0b56aefd3a2952f45c5123672f5f/raw/build-jar.sh | bash";

	# ````````````````````Wallpapers````````````````````````````
	# Clones your wallpapers into the correct folder
	wall-pull = "git clone https://github.com/y-jar/wall-bin.git ~/pic-jar/wall-bin";
    	wall-sync = "cd ~/pic-jar/wall-bin && git pull && cd -";

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
