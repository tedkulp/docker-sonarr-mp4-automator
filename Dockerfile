FROM jrottenberg/ffmpeg:4.2-ubuntu1804 as ffmpeg
FROM linuxserver/sonarr:latest

COPY --from=ffmpeg /usr/local/ /usr/local/

# Add sources
RUN sed -i -- 's/#deb-src/deb-src/g' /etc/apt/sources.list && sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list

RUN \
  apt-get update && \
  apt-get install -y \
  ffmpeg \
  git \
  python-pip \
  openssl \
  python-dev \
  libffi-dev \
  libssl-dev \
  libxml2-dev \
  libxslt1-dev \
  zlib1g-dev \
  libfdk-aac-dev \
  build-essential

RUN \
  git clone git://github.com/mdhiggins/sickbeard_mp4_automator.git /sickbeard_mp4_automator/ && \
  pip install -r /sickbeard_mp4_automator/setup/requirements.txt && \
  touch /sickbeard_mp4_automator/info.log && \
  chmod a+rwx -R /sickbeard_mp4_automator && \
  ln -s /downloads /data && \
  ln -s /config_mp4_automator/autoProcess.ini /sickbeard_mp4_automator/autoProcess.ini && \
  rm -rf \
  /tmp/* \
  /var/lib/apt/lists/* \
  /var/tmp/*

VOLUME /config_mp4_automator
