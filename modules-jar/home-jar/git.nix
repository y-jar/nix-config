{pkgs, ... }:
{
	programs.git = {
	  enable = true;
	  # this is just for me, but if anyone else uses this, either empty this file or rename creds and do your git sturrf
	  settings = {
	  	user = { 
			name = "y-jar";
			email = "park.7qs@gmail.com";
		};
	  	
	        init.defaultBranch = "main";
	        safe.directory = "/home/jar/nix-config"; # Prevents "dubious ownership" errors
	  };
	  
	};
}

