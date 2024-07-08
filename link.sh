#! /bin/bash

# .config/nvim/
mkdir -p $HOME/.config/
ln -s $HOME/dotfiles/.config/nvim/ $HOME/.config

# .gitconfig
ln -s $HOME/dotfiles/.gitconfig $HOME/.gitconfig

# .ssh/
ln -s $HOME/dotfiles/.ssh/ $HOME

# .tmux.conf
ln -s $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf

# .vimrc
ln -s $HOME/dotfiles/.vimrc $HOME/.vimrc

# .zshrc
ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc
