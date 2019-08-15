ARG PYTHON_VERSION=3.6.8-alpine3.9

FROM python:${PYTHON_VERSION} as builder

ENV PYTHONUNBUFFERED 1

# Set build directory
WORKDIR /wheels

# Copy files necessary
COPY ./requirements.txt /wheels/

# Perform build and cleanup artifacts
RUN \
  apk add --no-cache \
    git \
    git-fast-import \
    openssh \
    musl-dev \
    cairo-dev \
    pango-dev \
    libffi-dev \
    build-base \
    jpeg-dev \
    zlib-dev \
    gdk-pixbuf-dev \
  && rm -rf /tmp/*

# Python Dependencies
RUN pip3 install -U pip \
   && pip3 wheel -r /wheels/requirements.txt

WORKDIR /roboto-fonts
    
RUN wget -O Roboto.zip https://fonts.google.com/download?family=Roboto && \
    wget -O RobotoMono.zip https://fonts.google.com/download?family=Roboto%20Mono && \
    wget -O RobotoCondensed.zip https://fonts.google.com/download?family=Roboto%20Condensed && \    
    wget -O RobotoSlab.zip https://fonts.google.com/download?family=Roboto%20Slab && \    
    mkdir -p /roboto-fonts/Roboto && unzip -o Roboto.zip -d /roboto-fonts/Roboto && \
    mkdir -p /roboto-fonts/RobotoMono && unzip -o RobotoMono.zip -d /roboto-fonts/RobotoMono  && \
    mkdir -p /roboto-fonts/RobotoCondensed && unzip -o RobotoCondensed.zip -d /roboto-fonts/RobotoCondensed && \
    mkdir -p /roboto-fonts/RobotoSlab && unzip -o RobotoSlab.zip -d /roboto-fonts/RobotoSlab 

FROM python:${PYTHON_VERSION}

ENV PYTHONUNBUFFERED 1

LABEL "com.github.actions.name"="DockerPS MkDocs"
LABEL "com.github.actions.description"="Builds MkDocs Site Output"
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/donmstewart/mkdocs.git"
LABEL "homepage"="http://github.com/actions"
LABEL "maintainer"="Don Stewart <don.stewart@docker.com>"

# Perform build and cleanup artifacts
#
# Cairo & Pango need to use -dev versions due
# to issues loading gobject with the non-dev 
# versions on Alpine.
RUN \
  apk add --no-cache \
    git \
    git-fast-import \
    openssh \
    cairo-dev \ 
    pango-dev \
    gdk-pixbuf \
    libffi \
  && rm -rf /tmp/*

COPY --from=builder /wheels /wheels
COPY --from=builder /roboto-fonts/Roboto /usr/share/fonts/Roboto
COPY --from=builder /roboto-fonts/RobotoMono /usr/share/fonts/RobotoMono
COPY --from=builder /roboto-fonts/RobotoCondensed /usr/share/fonts/RobotoCondensed
COPY --from=builder /roboto-fonts/RobotoSlab /usr/share/fonts/RobotoSlab

# Python Dependencies
RUN pip3 install -U pip \
    && pip3 install --no-cache-dir \
      -r ./wheels/requirements.txt \
      -f /wheels \
    && rm -rf /wheels \
    && cd /usr/share/fonts && fc-cache -fv

# Set final MkDocs working directory
WORKDIR /mkdocs

# Expose MkDocs development server port
EXPOSE 8000

# Start development server by default
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
