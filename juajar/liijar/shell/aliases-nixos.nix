# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: NixOS-ONLY zsh aliases (nh / nixos-rebuild / host services).
# -=-=-=-=-=-=-=-=-=-=-=
# Only loaded by the zsh module when usrset.system.platform = "nixos". The portable
# set lives in ./aliases.nix. Takes `hostnm` so rebuild aliases target the right system.
# The llama / whale / authentik ones assume those system services exist on the host.
# -=-=-=-=-=-=-=-=-=-=-=
{ hostnm }:
{
  nht = "nh os test --accept-flake-config ~/nix-config#${hostnm}"; # base test
  nhs = "nh os switch --accept-flake-config ~/nix-config#${hostnm}"; # base switch
  nhc = "nh clean all --keep 7"; # base cleanup
  nrs = "nixos-rebuild switch --sudo --flake ~/nix-config#${hostnm}"; # hard building
  nrt = "nixos-rebuild test --sudo --flake ~/nix-config#${hostnm}"; # testing
  buildiso = "sh ~/nix-config/resjar/nixbin/buildiso.sh"; # build recovery ISO
  repl = "nix repl --file ~/nix-config/juajar/liijar/shell/repl.nix"; # poke the flake
  neconf = "cd /etc/nixos"; # nix config (system-installed mirror)
  rllm = "sudo systemctl restart llama-cpp";
  sllm = "sudo systemctl restart llama-cpp";
  stllm = "sudo systemctl start llama-cpp";
  grepauth = "sudo grep AUTHENTIK_BOOTSTRAP_PASSWORD /var/lib/authentik/env"; # grep authentik bootstrap password
  erroroutline = "journalctl -u outline-oidc-provision"; # journalctl for outline oidc provisioning
  whealth = "systemctl is-active outline authentik authentik-worker && ss -tln | grep -E ':(3001|9000) ' && curl -sk https://whale.local:3001/ -o /dev/null -w 'outline: HTTP %{http_code}' && echo && curl -s http://localhost:9000/if/flow/default-authentication-flow/ -o /dev/null -w 'authentik: HTTP %{http_code}'"; # post-switch whale check: services, ports, web endpoints
  wdry = "out=$(nix build --print-out-paths --no-link $HOME/nix-config#nixosConfigurations.$(hostname).config.system.build.toplevel) && echo BUILD-OK $out && sudo $out/bin/switch-to-configuration dry-activate && echo DRY-OK"; # pre-flight this host: build + dry-run activation (changes nothing)
}
