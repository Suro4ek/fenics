FROM suro4ek/fenics:arm

USER root

# Install dependencies for code-server
RUN apt-get update && \
    apt-get install -y curl wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create config directory
RUN mkdir -p /home/fenics/.config/code-server

# Configure code-server
RUN echo 'bind-addr: 0.0.0.0:8080\nauth: password\npassword: fenics\ncert: false' > /home/fenics/.config/code-server/config.yaml

# Fix permissions
RUN chown -R fenics:fenics /home/fenics/.config

USER fenics
WORKDIR /home/fenics

# Install Python extension
RUN code-server --install-extension ms-python.python || true

EXPOSE 8080

ENTRYPOINT ["/home/fenics/set_xvfb.sh"]
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "/home/fenics/shared"]
