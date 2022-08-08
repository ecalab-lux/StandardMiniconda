# This Dockerfile creates a jupyter lab server with miniconda3
FROM continuumio/miniconda3
ARG TARGET_MACHINE # This variable will be used to decide the UID/GID of the internal user to match the host. Important: after the FROM!!!
RUN TZ=Europe/Luxembourg ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install curl htop apt-utils
# Install Jupyterlab as a bare minimum
RUN conda install jupyterlab
RUN conda install jupytext -c conda-forge
# Create a non-root user
# Please match this with host machine desired uid and gid
RUN if [ "$TARGET_MACHINE" = 'ecadockerhub' ]; then echo "\n\033[0;32mBuilding for ecadockerhub\n\033[0;97m"; else echo "\n\033[0;32mBuilding for localhost\n\033[0;97m"; fi
# 901/954 for ecadockerhub, 1000/1000 for black
RUN if [ "$TARGET_MACHINE" = 'ecadockerhub' ]; then groupadd -r --gid 901 jupyter; else groupadd -r --gid 1000 jupyter; fi
RUN if [ "$TARGET_MACHINE" = 'ecadockerhub' ]; then useradd --no-log-init --uid 954 -r -m -g jupyter jupyter; else useradd --no-log-init --uid 1000 -r -m -g jupyter jupyter; fi
USER jupyter
WORKDIR /home/jupyter
ENV PATH=$PATH:/home/jupyter/.local/bin

# Generate self-signed SSL certificates
RUN openssl req -batch -x509 -nodes -days 730 -newkey rsa:2048 -keyout mykey.key -out mycert.pem -subj "/C=LU/ST=Luxembourg/O=ECALab"
RUN mkdir Notebooks
WORKDIR /home/jupyter/Notebooks
# Set-up the configurations
RUN conda config --add envs_dirs /opt/conda/envs
