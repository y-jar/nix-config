{pkgs, ... }:
{
	programs.git = {
	  enable = true;
	  userName = "y-jar";
	  userEmail = "park.7qs@gmail.com";
	  
	  extraConfig = {
	    init.defaultBranch = "main";
	    safe.directory = "/home/jar/nix-config"; # Prevents "dubious ownership" errors
	  };
	};
}

