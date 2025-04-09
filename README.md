# 💤 LazyVim - thejezzi

This was the starter template for [LazyVim](https://github.com/LazyVim/LazyVim)
and is the config I use for everyday work. God bless the people that maintain
and work on neovim and all those plugins!

## Prerequisites

Neovim 0.10.0 or higher is required as some plugins require it e.g nvim-snippets.

## Try it out with docker

You can try out my development environment by using my docker image that runs
my neovim config as well as my dotfiles.

```sh
# start the container
docker run -it --rm thejezzi/nvim

# inside the container just run nvim
nvim
```

When asked for a copilot login than just close and reopen neovim and it should
not bother you anymore.

### When using kitty

If you're using kitty and wonder why some of the colorschemes are broken than
try to specify the `TERM` environment variable.

```sh
docker run -it --rm -e TERM="$TERM" thejezzi/nvim
```

## Using CodeCompanion with MCPHub

Make sure to have `uv` installed. This can be done by using the shell script
from the official uv website or by installing via a package manager.

Various tools from MCPHub will also be installed via pnpm (because node_modules
are very large) which can be installed by running `npm i -g pnpm`
