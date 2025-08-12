ARG TARGETPLATFORM=
ARG BASE_IMAGE=

FROM --platform=${TARGETPLATFORM} ${BASE_IMAGE}

ARG FC_UID=
ARG FC_UN=
ARG FC_GID=

RUN apt-get -y update && apt-get -y install gcc file
RUN groupadd -g ${FC_GID} ${FC_GID} && useradd -u ${FC_UID} -g ${FC_GID} -m ${FC_UN}

RUN <<EOF
cat > /entrypoint.sh <<'SCRIPT' && chmod o+x /entrypoint.sh
#!/usr/bin/env bash
cd ./elf
gcc --version
gcc -pthread ../src/turtwig-rides-dirtycow.c && file ./a.out && ./a.out && rm a.out
echo 'gcc -pthread ../src/turtwig-rides-dirtycow.c -o ' >> ~/.bash_history && \
echo -e '"gcc -pthread ../src/turtwig-rides-dirtycow.c -o " is the lastcmd in the history, ready to use!\n'
sed -i '1iforce_color_prompt=yes' ~/.bashrc && source ~/.bashrc
exec bash
SCRIPT
EOF

# RUN chmod o+x /entrypoint.sh

WORKDIR /trdc

ENTRYPOINT ["/entrypoint.sh"]

