# Disable default greeting
set -U fish_greeting

# Set environment variables
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx DOTNET_ROOT ~/.dotnet
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1
set -gx DOTNET_NOLOGO 1
set -gx TNS_ADMIN ~/.oracle

# Modify $PATH environment variable
fish_add_path -g ~/.dotnet ~/.dotnet/tools ~/.local/bin ~/.cargo/bin ~/.local/share/nvm/v24.4.1/bin

if status is-login
    # Add homebrew into current shell (add to $PATH, $MANPATH, etc.)
    /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
end

if status is-interactive
    # Add custom command aliases
    alias ls='eza'
    alias ll='eza -lh --icons --git --git-ignore'
    alias la='eza -lha --icons'
    alias lt='eza --tree --icons --git-ignore'

    # Run starship prompt
    starship init fish | source
end
