FROM node:20-slim
ARG uid

RUN apt-get update && apt-get install -y \
    curl git ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# If uid is already taken (e.g. 1000, owned by the built-in "node" user),
# rename that account to juha. Otherwise create a fresh juha with the given uid.
RUN if getent passwd "${uid}" >/dev/null 2>&1; then \
        existing_name=$(getent passwd "${uid}" | cut -d: -f1); \
        usermod -l juha -d /home/juha -m "${existing_name}"; \
    else \
        useradd -u "${uid}" -m -s /bin/bash juha; \
    fi

USER juha
ENV HOME=/home/juha
ENV NPM_CONFIG_PREFIX=/home/juha/.npm-global
ENV PATH=/home/juha/.npm-global/bin:$PATH
RUN npm install -g @anthropic-ai/claude-code
RUN claude plugin marketplace add JuliusBrussee/caveman && claude plugin install caveman@caveman
WORKDIR /workspace
ENTRYPOINT ["claude"]
