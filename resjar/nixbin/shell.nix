# [shell.nix] TEMPLATE_CHANGEME_ME - copy & customize for your project
{
  pkgs ? import <nixpkgs> { },
}:
# create a shell enviroment
pkgs.mkShell {
  # [Install packages here] [refer to: https://search.nixos.org/packages for what pkgs]
  buildInputs = with pkgs; [
    # [base]
    neovim # Vim text editor fork focused on extensibility and agility
    vim # text editor
    git # version control
    pkg-config # Tool that allows packages to find out information about other packages (wrapper script)

    # [utility]
    jq # JSON processor
    yq-go # YAML processor (maintained yq; binary is `yq`)
    htop # interactive process monitor
    btop # modern system monitor

    # [python development]  [python3 = 3.13.15]
    # python3Packages.flet        # GUI framework (import flet as ft) v0.80.0
    # python3Packages.flet-cli    # flet run / build / create
    # python3Packages.pip         # package installer
    # python3Packages.pytest      # testing
    # python3Packages.requests    # http client

    # [node / js]
    # nodejs_22     # JS runtime (includes bundled npm)
    # typescript    # typed superset of JS
    # deno          # modern JS/TS runtime
    # bun           # fast all-in-one JS runtime

    # [rust]
    # rustc          # rust compiler
    # cargo          # rust package manager / build tool
    # rust-analyzer  # rust language server

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
    echo -e " \e[1;33m╃\e[0m"
    echo -e " \e[1;33m .▀▀█▀▀ .\e[0m"
    echo -e " \e[1;33m   :▓:.\e[0m"
    echo -e " \e[1;33m. ▀▀ : ╃\e[0m"
    echo -e "| Extra Commands:"
    echo -e "|   'nhc'            -> Clean up older system generations"
    echo -e "|   'chkhrd'         -> Check local storage blocks and partitions"
    echo -e "|"
    echo -e "| For more Help, refer to:"
    echo -e "|   \e]8;;https://github.com/y-jar/nix-config\e\\nix-config\e]8;;\e\\\\"
    # =============[prompt]

    # ================[Functions]
    #[grabs latest version]
    jars() {
        echo -e "\e[1;32m==> Fetching and syncing with main repository...\e[0m"
        git pull --rebase origin main
    }
    jc() {
        if [ -z "$*" ]; then
            echo -e "\e[1;31m|!!! Error: Specify your commit name! gotta document!\e[0m"
            return 1
        fi
        git commit -m "$*"
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