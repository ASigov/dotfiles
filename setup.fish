#!/usr/bin/env fish

function update_link
    if test -e $argv[2]
        rm $argv[2]
    end

    ln -s $argv[1] $argv[2]
end

update_link ~/dotfiles/git/.gitconfig ~/.gitconfig
update_link ~/dotfiles/fish/config.fish ~/.config/fish/config.fish
update_link ~/dotfiles/starship/starship.toml ~/.config/starship.toml
update_link ~/dotfiles/nvim ~/.config/nvim
