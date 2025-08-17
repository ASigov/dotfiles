set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx DOTNET_ROOT ~/.dotnet
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1
set -gx TNS_ADMIN ~/.oracle
fish_add_path -g ~/.dotnet ~/.dotnet/tools ~/.local/bin ~/.cargo/bin ~/.local/share/nvm/v24.4.1/bin

if status is-login
    /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
end

if status is-interactive
    alias ls='eza'
    alias ll='eza -lh --icons --git --git-ignore'
    alias la='eza -lha --icons'
    alias lt='eza --tree --icons --git-ignore'

    starship init fish | source
end
