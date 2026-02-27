{ pkgs, ... }:

{
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		
		# enables internal shit, idk, might remove if i find it useless
		withNodeJs = true;
		withPython3 = true;
		
		# Dependancies for my neovim config at y-jar/nvim
		# adds to PATH, how useful..
		extraPackages = [
			# Core Reqs
			pkgs.git
			pkgs.gcc # C Shit
			pkgs.gnumake
			pkgs.unzip
			pkgs.wget
			pkgs.curl
			pkgs.tree-sitter

			# Languages / runtimes
			pkgs.nodejs_22
			pkgs.python3
			pkgs.python312Packages.pip
			
			# Telescope / Search
			pkgs.ripgrep
			pkgs.fd
			
			# some lsps if not managed or something
			pkgs.lua-language-server
			pkgs.nil
			pkgs.nodePackages.typescript-language-server
		];
	};
}
