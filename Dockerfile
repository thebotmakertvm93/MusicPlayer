FROM python:3.10-slim-bookworm

# Updating Packages using stable modern mirrors
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends git curl ffmpeg build-essential python3-dev && \
    rm -rf /var/lib/apt/lists/*

# Copying Requirements
COPY requirements.txt /requirements.txt

# Installing Requirements
RUN cd /
RUN pip3 install --upgrade pip
RUN pip3 install -U -r requirements.txt

# Setting up working directory
RUN mkdir /MusicPlayer
WORKDIR /MusicPlayer

# Preparing for the Startup
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Running Music Player Bot
CMD ["/bin/bash", "/startup.sh"]
