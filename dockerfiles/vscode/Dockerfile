FROM suro4ek/fenics:arm

USER root

# Install dependencies for code-server
RUN apt-get update && \
    apt-get install -y curl wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create config directory and VS Code settings
RUN mkdir -p /home/fenics/.config/code-server \
    /home/fenics/.local/share/code-server/User

# Configure code-server
RUN echo 'bind-addr: 0.0.0.0:8080\nauth: password\npassword: fenics\ncert: false' > /home/fenics/.config/code-server/config.yaml

# Configure Python settings
RUN echo '{"python.languageServer": "Jedi", "python.defaultInterpreterPath": "/usr/bin/python3", "python.pythonPath": "/usr/bin/python3"}' > /home/fenics/.local/share/code-server/User/settings.json

# Fix permissions
RUN chown -R fenics:fenics /home/fenics/.config /home/fenics/.local

USER fenics
WORKDIR /home/fenics

# Install Python extension
RUN code-server --install-extension ms-python.python || true

EXPOSE 8080

ENTRYPOINT ["/home/fenics/set_xvfb.sh"]
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "/home/fenics/shared"]
