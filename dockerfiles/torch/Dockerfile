FROM suro4ek/fenics:arm

USER root

# Install torch (will have sympy conflict warning but should work)
RUN pip3 install torch 'sympy<1.12'

USER fenics
WORKDIR /home/fenics

ENTRYPOINT ["/home/fenics/set_xvfb.sh"]
CMD ["/bin/bash","-i"]
