{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, home-manager, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      environment.systemPackages =
        with pkgs; [
          vim
          htop
          neovim
          python311
          nodejs_22
          poetry
          tmux
        ];

      # Homebrew
      homebrew = {
        enable = true;
        casks = [
          "1password"
          "dbeaver-community"
          "kitty"
          "slack"
          "zed"
          "brave-browser"
          "firefox"
          "obsidian"
          "warp"
          "brave-browser"
          "proton-drive"
          "pdf-expert"
        ];
        onActivation = {
          autoUpdate = true;
          cleanup = "zap";
        };
      };

      # Yabai
      # services.yabai = {
      #   enable = true;
      #   enableScriptingAddition = true;
      #   config = {
      #     layout = "bsp";
      #   };
      #   extraConfig = ''
      #     yabai -m rule --add app="^Firefox$" space=2
      #     yabai -m rule --add app="^Warp$" space=1
      #     yabai -m config external_bar all:40:0
      #
      #   '';
      # };
      #
      # # SKHD
      # services.skhd = {
      #   enable = true;
      #   skhdConfig = ''
      #     ctrl - h: yabai -m window --focus west
      #     ctrl - j: yabai -m window --focus south
      #     ctrl - k: yabai -m window --focus north
      #     ctrl - l: yabai -m window --focus east
      #
      #     cmd - h: yabai -m space --focus prev
      #     cmd - l: yabai -m space --focus next
      #     cmd - z : yabai -m space --focus recent
      #     cmd - 1 : yabai -m space --focus 1
      #     cmd - 2 : yabai -m space --focus 2
      #     cmd - 3 : yabai -m space --focus 3
      #     cmd - 4 : yabai -m space --focus 4
      #     cmd - 5 : yabai -m space --focus 5
      #     cmd - 6 : yabai -m space --focus 6
      #     cmd - 7 : yabai -m space --focus 7
      #     cmd - 8 : yabai -m space --focus 8
      #     cmd - 9 : yabai -m space --focus 9
      #     cmd - 0 : yabai -m space --focus 10
      #
      #     cmd + shift - 1 : yabai -m window --space  1; yabai -m space --focus 1
      #     cmd + shift - 2 : yabai -m window --space  2; yabai -m space --focus 2
      #     cmd + shift - 3 : yabai -m window --space  3; yabai -m space --focus 3
      #     cmd + shift - 4 : yabai -m window --space  4; yabai -m space --focus 4
      #     cmd + shift - 5 : yabai -m window --space  5; yabai -m space --focus 5
      #     cmd + shift - 6 : yabai -m window --space  6; yabai -m space --focus 6
      #     cmd + shift - 7 : yabai -m window --space  7; yabai -m space --focus 7
      #     cmd + shift - 8 : yabai -m window --space  8; yabai -m space --focus 8
      #     cmd + shift - 9 : yabai -m window --space  9; yabai -m space --focus 9
      #     cmd + shift - 0 : yabai -m window --space 10; yabai -m space --focus 10
      #   '';
      # };
      #
      # # Sketchybar
      # services.sketchybar = {
      #   enable = true;
      # };
      #
      # Hide dock and menu bar:
      system.defaults = {
        dock.autohide = true;
        NSGlobalDomain._HIHideMenuBar = false;
      };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Enable TouchID for sudo:
      security.pam.enableSudoTouchIdAuth = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Fonts
      fonts = {
        fontDir.enable = true;
        fonts = with pkgs; [
          (nerdfonts.override {fonts = ["FantasqueSansMono" "Hack"];})
          font-awesome_5
        ];
      };

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."mac".pkgs;
  };
}
