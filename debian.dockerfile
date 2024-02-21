FROM debian:bookworm AS tools-builder

RUN apt update -y && apt upgrade -y \
 && apt install -y build-essential curl git unzip

WORKDIR /root/cica

ARG cica_ver=5.0.3
RUN curl -LO https://github.com/miiton/Cica/releases/download/v${cica_ver}/Cica_v${cica_ver}.zip \
 && unzip Cica_v${cica_ver}.zip \
 && mkdir -p /usr/share/fonts/cica \
 && mv Cica-*.ttf /usr/share/fonts/cica \
 && tar rvf /artifacts.tar.gz /usr/share/fonts/cica

WORKDIR /root/src

RUN git clone https://github.com/aristocratos/btop \
 && cd btop \
 && git checkout main \
 && make \
 && cp bin/btop /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/btop

WORKDIR /root

ARG go_ver=1.22.0

RUN curl -LO https://go.dev/dl/go${go_ver}.linux-amd64.tar.gz \
 && tar -C /usr/local -xzf go${go_ver}.linux-amd64.tar.gz

ENV GO_HOME=/root/go
ENV GO=/usr/local/go/bin/go

RUN $GO install github.com/muesli/duf@latest \
 && cp $GO_HOME/bin/duf /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/duf

RUN $GO install github.com/junegunn/fzf@latest \
 && cp $GO_HOME/bin/fzf /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/fzf

RUN $GO install github.com/jesseduffield/lazydocker@latest \
 && cp $GO_HOME/bin/lazydocker /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/lazydocker

RUN $GO install github.com/jesseduffield/lazygit@latest \
 && cp $GO_HOME/bin/lazygit /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/lazygit

RUN curl -o installer.sh --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
 && sh installer.sh -y --profile minimal

ENV CARGO_HOME=/root/.cargo
ENV CARGO=$CARGO_HOME/bin/cargo

RUN $CARGO install bat \
 && cp $CARGO_HOME/bin/bat /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/bat

RUN $CARGO install bingrep \
 && cp $CARGO_HOME/bin/bingrep /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/bingrep

RUN $CARGO install broot \
 && cp $CARGO_HOME/bin/broot /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/broot

RUN $CARGO install eza \
 && cp $CARGO_HOME/bin/eza /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/eza

RUN $CARGO install fd-find \
 && cp $CARGO_HOME/bin/fd /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/fd

RUN $CARGO install fselect \
 && cp $CARGO_HOME/bin/fselect /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/fselect

RUN $CARGO install git-delta \
 && cp $CARGO_HOME/bin/delta /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/delta

RUN $CARGO install gitui --version=0.24.3 \
 && cp $CARGO_HOME/bin/gitui /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/gitui

RUN $CARGO install git-interactive-rebase-tool \
 && cp $CARGO_HOME/bin/interactive-rebase-tool /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/interactive-rebase-tool

RUN $CARGO install hexyl \
 && cp $CARGO_HOME/bin/hexyl /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/hexyl

RUN $CARGO install lsd \
 && cp $CARGO_HOME/bin/lsd /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/lsd

RUN $CARGO install pastel \
 && cp $CARGO_HOME/bin/pastel /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/pastel

RUN $CARGO install procs \
 && cp $CARGO_HOME/bin/procs /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/procs

RUN $CARGO install pueue \
 && cp $CARGO_HOME/bin/pueue /usr/bin/ \
 && cp $CARGO_HOME/bin/pueued /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/pueue \
 && tar rvf /artifacts.tar.gz /usr/bin/pueued

RUN $CARGO install ripgrep \
 && cp $CARGO_HOME/bin/rg /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/rg

RUN $CARGO install ripgrep_all \
 && cp $CARGO_HOME/bin/rga /usr/bin/ \
 && cp $CARGO_HOME/bin/rga-fzf /usr/bin/ \
 && cp $CARGO_HOME/bin/rga-fzf-open /usr/bin/ \
 && cp $CARGO_HOME/bin/rga-preproc /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/rga \
 && tar rvf /artifacts.tar.gz /usr/bin/rga-fzf \
 && tar rvf /artifacts.tar.gz /usr/bin/rga-fzf-open \
 && tar rvf /artifacts.tar.gz /usr/bin/rga-preproc

RUN apt install -y libfontconfig1-dev libharfbuzz-dev libxcb1-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev python3 \
 && $CARGO install silicon \
 && cp $CARGO_HOME/bin/silicon /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/silicon \
 && tar rvf /artifacts.tar.gz /lib/x86_64-linux-gnu/libharfbuzz.so.0 \
 && tar rvf /artifacts.tar.gz /lib/x86_64-linux-gnu/libfontconfig.so.1 \
 && tar rvf /artifacts.tar.gz /lib/x86_64-linux-gnu/libfreetype.so.6 \
 && tar rvf /artifacts.tar.gz /lib/x86_64-linux-gnu/libxcb.so.1 \
 && tar rvf /artifacts.tar.gz /lib/x86_64-linux-gnu/libxcb-render.so.0 \
 && tar rvf /artifacts.tar.gz /lib/x86_64-linux-gnu/libxcb-shape.so.0 \
 && tar rvf /artifacts.tar.gz /lib/x86_64-linux-gnu/libxcb-xfixes.so.0 \
 && tar rvf /artifacts.tar.gz /lib/x86_64-linux-gnu/libgraphite2.so.3 \
 && tar rvf /artifacts.tar.gz /lib/x86_64-linux-gnu/libglib-2.0.so.0 \
 && tar rvf /artifacts.tar.gz /lib/x86_64-linux-gnu/libexpat.so.1 \
 && tar rvf /artifacts.tar.gz /lib/x86_64-linux-gnu/libpng16.so.16 \
 && tar rvf /artifacts.tar.gz /lib/x86_64-linux-gnu/libbrotlidec.so.1 \
 && tar rvf /artifacts.tar.gz /lib/x86_64-linux-gnu/libXau.so.6 \
 && tar rvf /artifacts.tar.gz /lib/x86_64-linux-gnu/libXdmcp.so.6 \
 && tar rvf /artifacts.tar.gz /lib/x86_64-linux-gnu/libbrotlicommon.so.1 \
 && tar rvf /artifacts.tar.gz /lib/x86_64-linux-gnu/libbsd.so.0

RUN $CARGO install skim \
 && cp $CARGO_HOME/bin/sk /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/sk

RUN $CARGO install tokei \
 && cp $CARGO_HOME/bin/tokei /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/tokei

RUN $CARGO install watchexec-cli \
 && cp $CARGO_HOME/bin/watchexec /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/watchexec

RUN $CARGO install zoxide \
 && cp $CARGO_HOME/bin/zoxide /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/zoxide

FROM debian:bookworm-slim

COPY --from=tools-builder /artifacts.tar.gz /

RUN apt update -y && apt upgrade -y \
 && tar xf /artifacts.tar.gz