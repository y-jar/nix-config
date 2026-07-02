# [shell.nix] This is a TEMPLATE file where other users can
{pkgs ? import <nixpkgs> {}}:
# create a shell enviroment
pkgs.mkShell {
  # [Install packages here] [refer to: https://search.nixos.org/packages for what pkgs]
  buildInputs = with pkgs; [
    # [base]
    neovim # Vim text editor fork focused on extensibility and agility
    vim # text editor
    git # version control
    pkg-config # Tool that allows packages to find out information about other packages (wrapper script)

    # [nix stuff]
    # nh # nix helper
    # nixd # Feature-rich Nix language server interoperating with C++ nix
    # nixfmt # Nix formatter
    # alejandra # formatter ~1.7mib
    # nil # Nix language server
  ]; # end of build inputs

  # hook: https://nix.dev/manual/nix/2.34/command-ref/nix-shell.html
  shellHook = ''
    # =============[prompt]
    echo -e "\e[1;33m====[ Entering Installer Shell for Nix in a Jar ]====\e[0m"
    echo -e "|"
    echo -e "|"
    echo -e "| Extra Commands:"
    echo -e "|   'nhc'            -> Clean up older system generations"
    echo -e "|   'chkhrd'         -> Check local storage blocks and partitions"
    echo -e "|"
    echo -e "| For more Help, refer to:"
    echo -e "|   \e]8;;file://$HOME/PATH/TO_FILE_DOT_TXT\e\\\\PLACEHOLDER_NAME\e]8;;\e\\\\"
    # =============[prompt]

    # ================[Functions]
    #[grabs latest version]
    jars() {
        echo -e "\e[1;32m==> Fetching and syncing with main repository...\e[0m"
        git pull --rebase origin main
    }
    # ================[Functions]

    # =======[aliases]
    #[tools]
    alias chkhrd="lsblk && fdisk -l"
    #[extras]
    alias cl="clear"
    alias ga="git add ."
    # =======[aliases]
  '';
}
