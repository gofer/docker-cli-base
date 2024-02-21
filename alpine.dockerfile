FROM alpine:3.19 AS tools-builder

RUN apk update && apk upgrade \
 && apk add alpine-sdk build-base curl gcc g++ git musl-dev openssl-dev openssl-libs-static unzip

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
 && ADDFLAGS='-fno-ipa-cp' make \
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

RUN OPENSSL_NO_VENDOR=Y $CARGO install gitui \
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

# RUN $CARGO install silicon

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

FROM alpine:3.19

COPY --from=tools-builder /artifacts.tar.gz /

RUN apk update && apk upgrade \
 && tar xf /artifacts.tar.gz
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

RUN OPENSSL_NO_VENDOR=Y $CARGO install gitui \
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

# RUN $CARGO install silicon

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

FROM alpine:3.19

COPY --from=tools-builder /artifacts.tar.gz /

RUN apk update && apk upgrade \
 && tar xf /artifacts.tar.gz