FROM fedora:40 AS base
RUN dnf upgrade --refresh -y

FROM base AS build

RUN dnf upgrade --refresh -y
RUN dnf update -y && dnf install -y \
  gcc cmake ninja-build curl gettext git unzip make glibc-gconv-extra 

RUN git clone https://github.com/neovim/neovim.git
WORKDIR /neovim
RUN git checkout master && \
  make CMAKE_BUILD_TYPE=RelWithDebInfo install

FROM base 

RUN dnf update -y && \
  dnf groupinstall -y "Development Tools" && \
  dnf install -y \
  cmake curl git make clang clang-tools-extra fd-find \
  ripgrep zsh stow tmux zoxide nodejs golang dnf-plugins-core which

RUN dnf copr enable atim/lazygit -y && \
  dnf install lazygit -y && \
  dnf clean all


RUN curl -L https://github.com/kaplanelad/shellfirm/releases/download/v0.2.10/shellfirm-v0.2.10-x86_64-linux.tar.xz -o shellfirm.tar.xz && \
  tar -xf shellfirm.tar.xz && \
  mv shellfirm-v0.2.10-x86_64-linux/shellfirm /usr/local/bin/shellfirm && \
  chmod +x /usr/local/bin/shellfirm && \
  rm -rf shellfirm.tar.xz shellfirm-v0.2.10-x86_64-linux



COPY --from=build /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=build /usr/local/share/nvim/ /usr/local/share/nvim/

ARG USERNAME=flo
WORKDIR /home/$USERNAME
ENV ZSH="/home/$USERNAME/.oh-my-zsh"
ENV SHELL=/bin/zsh
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y && \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
  git clone https://github.com/thejezzi/dotfiles


WORKDIR /home/$USERNAME/dotfiles
RUN git submodule update --init && \
  stow . --adopt


ARG USER_UID=1001
ARG USER_GID=1001
RUN groupadd --gid $USER_GID $USERNAME && \
  useradd --uid $USER_UID --gid $USER_GID --home-dir /home/$USERNAME --create-home $USERNAME && \
  echo "$USERNAME:password" | chpasswd && \
  usermod -aG wheel $USERNAME && \
  echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
  chown -R $USERNAME:$USERNAME /home/$USERNAME

WORKDIR /home/$USERNAME
USER $USERNAME

RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && \
  git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting && \
  curl https://raw.githubusercontent.com/kaplanelad/shellfirm/main/shell-plugins/shellfirm.plugin.oh-my-zsh.zsh \
  --create-dirs -o ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/shellfirm/shellfirm.plugin.zsh && \
  # Install rust
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

CMD ["zsh"]

