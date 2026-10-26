{ pkgs, ... }: {
  imports = [

  ];

  programs.tmux = {
    enable = true;
    shortcut = "t";
    # aggressiveResize = true; -- Disabled to be iTerm-friendly
    clock24 = true;
    baseIndex = 1;
    # newSession = true;
    # Stop tmux+escape craziness.
    escapeTime = 0;
    # Force tmux to use /tmp for sockets (WSL2 compat)
    secureSocket = true;
    historyLimit = 50000;

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.resurrect
      tmuxPlugins.catppuccin
      tmuxPlugins.battery
    ];

    extraConfig = ''
      set -g status-position top # move status bar to the top
      # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"

      set-option -g extended-keys always
      set -as terminal-features 'xterm*:extkeys'

#      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      # Mouse works as expected
      set-option -g mouse on

      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind -  split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Configure the catppuccin plugin
      set -g @catppuccin_flavor "mocha" # latte, frappe, macchiato, or mocha
      set -g @catppuccin_window_status_style "rounded" # basic, rounded, slanted, custom, or none

     # Change prefix from 'Ctrl+b' to 'Ctrl+t'
#      unbind C-b
#      set-option -g prefix C-t
#      bind-key C-t send-prefix

      # Add battery
#      run-shell ~/clone/path/battery.tmux
      # set -g status-right 'Batt: #{battery_icon} #{battery_percentage} #{battery_remain} | %a %h-%d %H:%M '
      # blank copy from example
      # set -g status-right "Icon: #{battery_icon} | #{battery_icon_charge} | Status: #{battery_icon_status} | Per: #{battery_percentage}"


      tmux_conf_battery_bar_symbol_full="◼"
      tmux_conf_battery_bar_symbol_empty="◻"
      tmux_conf_battery_bar_length="auto"
      tmux_conf_battery_bar_palette="gradient"
      tmux_conf_battery_hbar_palette="gradient"
      tmux_conf_battery_vbar_palette="gradient"
      tmux_conf_battery_status_charging="↑"       # U+2191
      tmux_conf_battery_status_discharging="↓"    # U+2193
      #tmux_conf_battery_status_charging="🔌"     # U+1F50C
      #tmux_conf_battery_status_discharging="🔋"  # U+1F50B

#      tmux_conf_theme_status_right=" #{?battery_status,#{battery_status},}#{?battery_bar, #{battery_bar},}#{?battery_percentage, #{battery_percentage},} , %R , %d %b | #{username}#{root} | #{hostname} "

#      set -g status-right 'Batt: #{battery_icon} #{battery_percentage} #{battery_remain} | %a %h-%d %H:%M '
#      set -g status-right "Icon: #{battery_icon} | Charge Icon: #{battery_icon_charge} | Status Icon: #{battery_icon_status} | Percent: #{battery_percentage} | Remain: #{battery_remain}"
#      set -g status-right-length '100'

#      set -g status-right 'Battery: #{battery_percentage} #{battery_icon} | %H:%M'
      set -g status-right '#{battery_color_bg} Batt: #{battery_icon} #{battery_percentage} #{battery_remain} | %H:%M %a %d-%h'
    '';
  };
}
