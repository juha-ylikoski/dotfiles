FROM node:20-slim

RUN apt-get update && apt-get install -y \
    curl git ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# node:20-slim already has gid 1000 (node group), just create user juha reusing it
RUN useradd -u 1000 -g 1000 -m -s /bin/bash juha 2>/dev/null || \
    usermod -l juha -d /home/juha -m $(getent passwd 1000 | cut -d: -f1) 

USER juha
ENV HOME=/home/juha
ENV NPM_CONFIG_PREFIX=/home/juha/.npm-global
ENV PATH=/home/juha/.npm-global/bin:$PATH

RUN npm install -g @anthropic-ai/claude-code

RUN claude plugin marketplace add JuliusBrussee/caveman && claude plugin install caveman@caveman

WORKDIR /workspace

ENTRYPOINT ["claude"]
