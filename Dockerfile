FROM alpine:3.15 as default
ARG IMGVERSION

LABEL org.label-schema.name="Base Container"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.description="This is the image that other images are based on"
LABEL org.label-schema.url="https://github.com/MartijnDekkers-EI/docker-base/blob/main/README.md"
LABEL org.label-schema.vcs-url="https://github.com/MartijnDekkers-EI/docker-base"
LABEL org.label-schema.version=${IMGVERSION}

# Install basic utils
RUN apk update && \
    apk add --no-cache libcap su-exec curl tzdata unzip wget \

# Get ContainerPilot, Consul, Vault, Consul Template, and dumb-init
RUN curl -Lso /tmp/containerpilot.tar.gz "https://github.com/greenbaum/containerpilot/releases/download/3.8.5/containerpilot-3.8.5.tar.gz" \
    && echo "a515198e11b0f20f279f3663cebf16a9261219031e40c5047d5bb2bc09df3f21 /tmp/containerpilot.tar.gz" | sha256sum -c \
    && tar zxf /tmp/containerpilot.tar.gz -C /bin \
    && rm /tmp/containerpilot.tar.gz \
    && curl -Lso /tmp/consul.zip "https://releases.hashicorp.com/consul/1.15.3/consul_1.15.3_linux_amd64.zip" \
    && echo "86c6fe308d2e4eea106d21e20c307726eb87be87eab1f6dfb0d53db81b31d334 /tmp/consul.zip" | sha256sum -c \
    && unzip /tmp/consul.zip -d /bin \
    && rm /tmp/consul.zip \
    && curl -Lso /tmp/vault.zip "https://releases.hashicorp.com/vault/1.13.3/vault_1.13.3_linux_amd64.zip" \
    && echo "7ca502f1c50dd043862276705b4ccc1fa45f633345ca7d01fc5b4ba1d820c51e /tmp/vault.zip" | sha256sum -c \
    && unzip /tmp/vault.zip -d /bin \
    && rm /tmp/vault.zip \
    && curl -Lso /tmp/consul-template.zip "https://releases.hashicorp.com/consul-template/0.32.0/consul-template_0.32.0_linux_amd64.zip" \
    && echo "eda83e12a4618929a3ec0a49b11a2823b6201c9ae64e5a15161fd63313caf88b /tmp/consul-template.zip" | sha256sum -c \
    && unzip /tmp/consul-template.zip -d /usr/local/bin \
    && rm /tmp/consul-template.zip \
    && curl -Lso /tmp/dumb-init "https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64" \
    && echo "e874b55f3279ca41415d290c512a7ba9d08f98041b28ae7c2acb19a545f1c4df /tmp/dumb-init" | sha256sum -c \
    && mv /tmp/dumb-init /bin/dumb-init \
    && chmod +x /bin/dumb-init \