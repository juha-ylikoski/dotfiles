FROM node:20-slim
ARG uid 
ARG docker_gid

# ---------------------------------------------------------------------------
# Base packages
# ---------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git ca-certificates gnupg unzip xz-utils build-essential pkg-config \
    cmake ninja-build clang lld lldb clang-format clang-tidy libssl-dev pkg-config && \
    rm -rf /var/lib/apt/lists/* 

# ---------------------------------------------------------------------------
# Go (system-wide -> /usr/local/go)
# ---------------------------------------------------------------------------
RUN ARCH=$(dpkg --print-architecture) && \
    GO_VERSION=$(curl -fsSL "https://go.dev/VERSION?m=text" | head -n1) && \
    curl -fsSL "https://go.dev/dl/${GO_VERSION}.linux-${ARCH}.tar.gz" -o /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz 

# ---------------------------------------------------------------------------
# OpenTofu (apt repo via official installer)
# ---------------------------------------------------------------------------
RUN curl -fsSL https://get.opentofu.org/install-opentofu.sh -o /tmp/install-opentofu.sh && \
    chmod +x /tmp/install-opentofu.sh && \
    /tmp/install-opentofu.sh --install-method deb && \
    rm -f /tmp/install-opentofu.sh && \
    rm -rf /var/lib/apt/lists/* 

# ---------------------------------------------------------------------------
# Docker CLI + buildx + compose plugins
# (talks to a mounted /var/run/docker.sock; no engine/daemon in-image)
# ---------------------------------------------------------------------------
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
        > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends docker-ce-cli docker-buildx-plugin docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/* 

# ---------------------------------------------------------------------------
# kubectl (system-wide)
# ---------------------------------------------------------------------------
RUN ARCH=$(dpkg --print-architecture) && \
    KVER=$(curl -fsSL https://dl.k8s.io/release/stable.txt) && \
    curl -fsSL "https://dl.k8s.io/release/${KVER}/bin/linux/${ARCH}/kubectl" -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl 

# ---------------------------------------------------------------------------
# Helm (system-wide, official installer -> /usr/local/bin)
# ---------------------------------------------------------------------------
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 -o /tmp/get-helm-3 && \
    chmod +x /tmp/get-helm-3 && \
    /tmp/get-helm-3 && \
    rm -f /tmp/get-helm-3 

# ---------------------------------------------------------------------------
# User setup
# If uid is already taken (e.g. 1000, owned by the built-in "node" user),
# rename that account to juha. Otherwise create a fresh juha with the given uid.
# ---------------------------------------------------------------------------
RUN if getent passwd "${uid}" >/dev/null 2>&1; then \
        existing_name=$(getent passwd "${uid}" | cut -d: -f1); \
        usermod -l juha -d /home/juha -m "${existing_name}"; \
    else \
        useradd -u "${uid}" -m -s /bin/bash juha; \
    fi && \
    if getent group "${docker_gid}" >/dev/null 2>&1; then \
        existing_name=$(getent group "${docker_gid}" | cut -d: -f1); \
        groupmod -n docker "${existing_name}"; \
    else \
        groupadd -g ${docker_gid} docker; \
    fi && \
    usermod -aG "$docker_gid" juha 

USER juha
ENV HOME=/home/juha
ENV GOPATH=/home/juha/go
ENV NPM_CONFIG_PREFIX=/home/juha/.npm-global
ENV PATH=/home/juha/.npm-global/bin:/home/juha/.cargo/bin:/home/juha/.local/bin:/usr/local/go/bin:/home/juha/go/bin:$PATH

# ---------------------------------------------------------------------------
# Claude Code + plugin
# ---------------------------------------------------------------------------
RUN npm install -g @anthropic-ai/claude-code 
RUN claude plugin marketplace add JuliusBrussee/caveman && claude plugin install caveman@caveman 

# ---------------------------------------------------------------------------
# Rust (rustup -> ~/.cargo, ~/.rustup)
# ---------------------------------------------------------------------------
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --quiet -y
RUN rustup component add llvm-tools-preview && \
    cargo install cargo-llvm-cov 

# ---------------------------------------------------------------------------
# Python via uv (-> ~/.local/bin)
# ---------------------------------------------------------------------------
RUN curl -LsSf https://astral.sh/uv/install.sh | sh 

WORKDIR /workspace
ENTRYPOINT ["claude"]
