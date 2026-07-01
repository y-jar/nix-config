# shell.nix
{pkgs ? import <nixpkgs> {}}:
# create a shell enviroment
pkgs.mkShell {
  buildInputs = with pkgs; [
    # [base]
    neovim # Vim text editor fork focused on extensibility and agility
    vim # text editor
    nh # nix helper
    git # version control
    pkg-config # Tool that allows packages to find out information about other packages (wrapper script)

    # [nix stuff]
    nixd # Feature-rich Nix language server interoperating with C++ nix
    nixfmt # Nix formatter
    alejandra # formatter ~1.7mib
    nil # Nix language server
  ]; # end of build inputs

  # hook: https://nix.dev/manual/nix/2.34/command-ref/nix-shell.html
  shellHook = ''
    echo -e "\e[1;33m====[ Entering Installer Shell for Nix in a Jar ]====\e[0m"
    echo -e "|"
    echo -e "| Tools: git, nh, and some others.."
    echo -e "| Some Commands:"
    echo -e "|   nhs +_ [hostName] -> Switches system configuration [defaults to current host]"
    echo -e "|   nht +_ [hostName] -> Tests system configuration [defaults to current host]"
    echo -e "|   nhc        -> Cleans up older generations [if ye soo inclined]"
    echo -e "|   chkhrd     -> Checks storage blocks and partitions"
    echo -e "|"

    # =======[aliases]
    #[sys]
    nhs() {
        nh os switch ~/nix-config#"$1"
    }
    nht() {
        nh os test ~/nix-config#"$1"
    }
    alias nhc="nh clean all --keep 7"; # base cleanup
    #[tools]
    alias chkhrd="lsblk && fdisk -l"
    #[extras]
    alias cl="clear"
    alias ga="git add ."
  '';
}
