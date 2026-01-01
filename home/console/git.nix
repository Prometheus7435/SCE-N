{ pkgs, ... }: {
  programs = {
    gh = {
      enable = true;
      extensions = with pkgs; [ gh-markdown-preview ];
      # extensions = with pkgs.unstable; [ gh-markdown-preview ];
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };

    delta = {
      enable = true;
      options = {
        features = "decorations";
        navigate = true;
        side-by-side = true;
      };
    };

    git = {
      enable = true;


      settings = {
        aliases = {
          lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        };
        user = {
          Name = "Zach Bombay";
          Email = "zacharybombay@gmail.com";
        };

#      extraConfig = {
        push = {
          default = "matching";
        };
        pull = {
          rebase = true;
        };
        init = {
          defaultBranch = "main";
        };
 #     };
      };

      ignores = [
        "*.log"
        "*.out"
        "*.pdf"
        # "*.lock"
        ".DS_Store"
        "bin/"
        "dist/"
        "result"
      ];
    };
  };
}
