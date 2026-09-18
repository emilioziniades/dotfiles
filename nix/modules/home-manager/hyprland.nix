{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ez.programs.hyprland;
in
{
  options.ez.programs.hyprland.enable = lib.mkEnableOption "Hyprland configuration";

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      configType = "lua";
      extraLuaFiles.config = ../../../hyprland/hyprland.lua;
    };

    home.packages = [
      pkgs.hyprlauncher
    ];

    gtk = {
      enable = true;
      colorScheme = "dark";
    };

    home.pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    xdg.configFile = {
      "hypr/hyprtoolkit.conf".text = ''
        background = 0xFF0B1020
        base = 0xFF111827
        text = 0xFFE5E7EB
        alternate_base = 0xFF1F2937
        bright_text = 0xFFFFFFFF
        accent = 0xFF33CCFF
        accent_secondary = 0xFF00FF99

        font_size = 13
        small_font_size = 11
        rounding_large = 16
        rounding_small = 8
      '';

      "hypr/hyprlauncher.conf".text = ''
        finders {
          default_finder = desktop
          desktop_icons = true
        }

        ui {
          window_size = 640 420
        }
      '';

      "hypr/hyprlock.conf".text = ''
        general {
          hide_cursor = true
          immediate_render = true
        }

        background {
          monitor =
          path = screenshot
          color = rgba(11, 16, 32, 1.0)
          blur_passes = 3
          blur_size = 8
          brightness = 0.55
          vibrancy = 0.12
        }

        label {
          monitor =
          text = $TIME
          color = rgba(255, 255, 255, 0.95)
          font_size = 80
          halign = center
          valign = center
          position = 0, 100
        }

        label {
          monitor =
          text = cmd[update:60000] date '+%A, %d %B'
          color = rgba(229, 231, 235, 0.85)
          font_size = 18
          halign = center
          valign = center
          position = 0, 35
        }

        input-field {
          monitor =
          size = 300, 54
          outline_thickness = 2
          dots_size = 0.2
          dots_spacing = 0.25
          dots_center = true
          outer_color = rgba(51, 204, 255, 0.8)
          inner_color = rgba(17, 24, 39, 0.8)
          font_color = rgba(229, 231, 235, 1.0)
          fade_on_empty = false
          placeholder_text = <i>Password</i>
          fail_color = rgba(255, 85, 85, 0.9)
          check_color = rgba(0, 255, 153, 0.9)
          halign = center
          valign = center
          position = 0, -70
        }
      '';

      "hypr/hypridle.conf".text = ''
        general {
          lock_cmd = pidof hyprlock || hyprlock
          before_sleep_cmd = loginctl lock-session
          after_sleep_cmd = hyprctl dispatch dpms on
        }

        listener {
          timeout = 300
          on-timeout = loginctl lock-session
        }

      '';
    };

    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        targets = [ "hyprland-session.target" ];
      };
      settings.mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 8;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "pulseaudio"
          "network"
          "battery"
          "clock"
        ];

        "hyprland/workspaces".format = "{name}";
        "hyprland/window".max-length = 60;
        pulseaudio = {
          format = "{volume}%";
          format-muted = "muted";
        };
        network = {
          format-wifi = "{signalStrength}%";
          format-ethernet = "wired";
          format-disconnected = "offline";
        };
        battery = {
          format = "{capacity}%";
          format-charging = "charging {capacity}%";
        };
        clock.format = "{:%a %d %b  %H:%M}";
      };
      style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: sans-serif;
          font-size: 13px;
        }

        window#waybar {
          background: rgba(26, 26, 26, 0.92);
          color: #e6e6e6;
        }

        #workspaces button,
        #pulseaudio,
        #network,
        #battery,
        #clock,
        #window {
          padding: 0 9px;
        }

        #workspaces button.active {
          color: #33ccff;
        }

        #workspaces button.urgent {
          color: #ff5555;
        }
      '';
    };

  };
}
