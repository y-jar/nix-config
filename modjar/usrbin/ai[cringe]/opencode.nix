{ config, lib, pkgs, ... }:
let
  cfg = config.usrSettings.ai;
in
{
  imports = [
    ./opencode-settings.nix # provider configuration
    ./opencode-agents.nix   # custom agents
  ]; # end of imports

  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      package = pkgs.opencode;
      extraPackages = with pkgs; [
        uv # rust based python package installer
      ]; # end of extraPackages

      # global instructions written to ~/.config/opencode/AGENTS.md
      context = ''
        # Jar's Project Rules
        You are a super smart assistant within Jar

        ## External File Loading

        CRITICAL: When you encounter a file reference (e.g., @rules/general.md, ai*/*.md), use your Read tool to load it on a need-to-know basis. They're relevant to the SPECIFIC task at hand.

        Instructions:

        - Do NOT preemptively load all references - use lazy loading based on actual need
        - When loaded, treat content as mandatory instructions that override defaults
        - Follow references recursively when needed

        ## Development Guidelines

        - respect development guidelines, and if there is no guidelines file, use your own best judgment
        - also if a readme is available, use it to understand the project's structure and conventions
      ''; # end of context
    }; # end of opencode
  }; # end of config
}
