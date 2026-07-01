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
    # =============[prompt]
    echo -e "\e[1;33m====[ Entering Installer Shell for Nix in a Jar ]====\e[0m"
    echo -e "|"
    echo -e "| Core Onboarding Steps:"
    echo -e "|   1. '\e[1;32mhardto <hostname>\e[0m' -> Copy template & grab local hardware config"
    echo -e "|   1.5. Go inside flake.nix and add the nixos config for your host[if you need to add one]"
    echo -e "|   2. Modify your configurations inside hstjar/<hostname>/"
    echo -e "|   3. '\e[1;32mnhs <hostname>\e[0m'    -> Switch into your new system configuration"
    echo -e "|"
    echo -e "| Extra Commands:"
    echo -e "|   'nht <hostname>' -> Test a system configuration change"
    echo -e "|   'nhc'            -> Clean up older system generations"
    echo -e "|   'chkhrd'         -> Check local storage blocks and partitions"
    echo -e "|   'ctrl+D' or `exit` -> Exit when you are done!"
    echo -e "|"
    echo -e "| For more Help, refer to:"
    echo -e "|   \e]8;;file://$HOME/nix-config/resjar/docbin/install-guide.md\e\\\\install-guide\e]8;;\e\\\\"
    echo -e "|   \e]8;;file://$HOME/nix-config/resjar/docbin/key-key.md\e\\\\documents-key\e]8;;\e\\\\"
    echo -e "|   \e]8;;file://$HOME/nix-config/README.md\e\\\\README\e]8;;\e\\\\"
    # =============[prompt]

    # [force features so flakes work] [if not there, nh will not work]
    export NIX_CONFIG="experimental-features = nix-command flakes"

    # ================[Functions]
    #[grab hardware]:
    hardto() {
        # [yoinks the hardware-configuration.nix over to the picked host dir in hstjar/]
        # [if no host is there, it will make a new one]
        if [ -z "$1" ]; then
            echo -e "\e[1;31m|!!! Error: You must specify a host target! [e.g., hardto yilyonix]\e[0m"
            return 1
        fi

        # [vars]
        local target_dir="$HOME/nix-config/hstjar/$1" # user picked host
        local template_dir="$HOME/nix-config/hstjar/0_TEMPLATE" # base template for systems

        # [Safety Check]: Don't overwrite an existing host profile
        if [ -d "$target_dir" ]; then
            echo -e "\e[1;33m|!!! Warning: Host directory '$1' already exists. Skipping template copy.\e[0m"
        else
            # [Copy the entire template directory layout recursively (-r)]
            if [ -d "$template_dir" ]; then
                echo -e "\e[1;32m==> Copying template to $target_dir/\e[0m"
                cp -r "$template_dir" "$target_dir"
                echo -e "\e[1;32m|!!! $1 is now a fresh system, /\e[0m"
                echo -e "|!!!  Please fill out $1's system.nix and user.nix"
                echo -e "|!!!  Please copy the template in the flake.nix and set it up for $1"
            else
                echo -e "\e[1;31m|!!! Error: Could not find template directory at $template_dir\e[0m"
                return 1
            fi # end of copy
        fi # end of safty check

        # [Yoink the hardware-configuration file right into the new setup]
        if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
            echo -e "\e[1;32m==> Yoinking /etc/nixos/hardware-configuration.nix into place\e[0m"
            cp /etc/nixos/hardware-configuration.nix "$target_dir/hardware-configuration.nix"
        else
            echo -e "\e[1;33mWarning: /etc/nixos/hardware-configuration.nix not found. [Are you running on a live ISO?]\e[0m"
        fi # end of yoink

        # [Stage everything so Nix Flakes can see the new files]
        git add "$target_dir"
        echo -e "\e[1;34m==> Successfully tracked new host '$1' in git.\e[0m"
    } # end of hardto
    #
    #[sys]
    nhs() {
        nh os switch ~/nix-config#"$1"
    } # end of nhs
    nht() {
        nh os test ~/nix-config#"$1"
    } # end of nht
    # ================[Functions]

    # =======[aliases]
    alias nhc="nh clean all --keep 7"; # base cleanup
    #[tools]
    alias chkhrd="lsblk && fdisk -l"
    #[extras]
    alias cl="clear"
    alias ga="git add ."
    # =======[aliases]
  '';
}
