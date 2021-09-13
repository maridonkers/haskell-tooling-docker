# Haskell tooling (a.o. stack & cabal) in a Docker container.
# See e.g.: https://docs.haskellstack.org/en/stable/install_and_upgrade/
# To manually set up your tooling from within this container (`make shell`).

FROM debian:latest

# Timezone is also in docker-compose file.
ENV HOME /root
ENV TZ Europe/Amsterdam
ENV SHELL /bin/bash

# Install dependencies that are likely required for the tooling.
RUN apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y procps lsof sudo curl less vim-nox zip git build-essential \
                       g++ gcc libc6-dev libffi-dev libgmp-dev make xz-utils \
                       zlib1g-dev git gnupg netbase; \
    apt-get clean

RUN sed -i "s#\smain\s*\$# main contrib non-free#" /etc/apt/sources.list

# Create a non-root account to run Haskell tooling with.
RUN useradd -ms /bin/bash --uid 1000 --gid 100 haskell; \
    usermod -G audio,video,sudo haskell; \
    echo 'haskell:@haskell!' | chpasswd

USER haskell
WORKDIR /home/haskell
RUN mkdir -p /home/haskell/bin
ENV HOME /home/haskell
ENV PATH="${PATH}:/home/haskell/bin:/home/haskell/.local/bin"
ENV DISPLAY=":0"

# ENTRYPOINT ["/bin/bash"]
