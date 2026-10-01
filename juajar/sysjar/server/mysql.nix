# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: MySQL/MariaDB server (localhost by default) + optional workbench + backups.
# -=-=-=-=-=-=-=-=-=-=-=
# `flavor` picks the engine per host: mariadb (default) or mysql (Oracle MySQL 8.x).
# Keep bindAddress = 127.0.0.1 and openFirewall = false for local-only use.
# `users` use unix-socket auth (no password) good for local apps; for TCP
# logins create a passworded user yourself (or via `initialScript`).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sysset.server.mysql;

  dbPackage = if cfg.flavor == "mysql" then pkgs.mysql84 else pkgs.mariadb;
in
{
  options = {
    sysset.server.mysql = {
      enable = lib.mkEnableOption "MySQL/MariaDB server";

      flavor = lib.mkOption {
        type = lib.types.enum [
          "mariadb"
          "mysql"
        ];
        default = "mariadb";
        description = "DB engine: mariadb (default) or mysql (Oracle MySQL 8.x, pkgs.mysql84).";
      }; # end of flavor

      port = lib.mkOption {
        type = lib.types.port;
        default = 3306;
      }; # end of port

      bindAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Address mysqld binds to. Keep 127.0.0.1 for localhost-only.";
      }; # end of bindAddress

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open the MySQL port in the firewall (only needed for non-localhost access).";
      }; # end of openFirewall

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/mysql";
      }; # end of dataDir

      databases = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Databases to ensure exist (CREATE DATABASE if missing).";
      }; # end of databases

      users = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption { type = lib.types.str; };
              ensurePermissions = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                default = { };
                description = "GRANT map, e.g. { \"mydb.*\" = \"ALL PRIVILEGES\"; }. Users get unix-socket auth (no password).";
              };
            };
          }
        );
        default = [ ];
        description = "DB users to ensure (unix-socket auth, no password).";
      }; # end of users

      settings = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "Extra my.cnf settings merged under services.mysql.settings.mysqld.";
      }; # end of settings

      initialScript = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "SQL script run once on first start (e.g. a passworded user).";
      }; # end of initialScript

      workbench = lib.mkEnableOption "mysql-workbench GUI client (desktop hosts)";

      backup = {
        enable = lib.mkEnableOption "scheduled mysqldump backups";
        location = lib.mkOption {
          type = lib.types.path;
          default = "/var/backup/mysql";
        }; # end of location
        calendar = lib.mkOption {
          type = lib.types.str;
          default = "01:15:00";
          description = "systemd OnCalendar expression for the backup timer.";
        }; # end of calendar
        databases = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Databases to dump (empty = nothing backed up).";
        }; # end of databases
      }; # end of backup
    }; # end of sysset.server.mysql
  }; # end of options

  config = lib.mkIf cfg.enable {
    services.mysql = {
      enable = true;
      package = dbPackage;
      inherit (cfg) dataDir initialScript;
      settings.mysqld = lib.mkMerge [
        (lib.listToAttrs [
          (lib.nameValuePair "port" cfg.port)
          (lib.nameValuePair "bind-address" cfg.bindAddress)
        ])
        cfg.settings
      ];
      ensureDatabases = cfg.databases;
      ensureUsers = cfg.users;
    }; # end of services.mysql

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    environment.systemPackages = lib.mkIf cfg.workbench [ pkgs.mysql-workbench ];

    services.mysqlBackup = lib.mkIf cfg.backup.enable {
      enable = true;
      inherit (cfg.backup) location calendar databases;
    }; # end of services.mysqlBackup
  }; # end of config
}
