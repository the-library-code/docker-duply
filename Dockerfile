FROM python:3-slim-buster

ENV DUPLICITY_VERSION=0.8.15

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        bash \
        gcc \
        gettext \
        gnupg \
        lftp \
        libffi-dev \
        librsync-dev \
        openssh-client \
        openssl \
        psutils \
        rsync \
        wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN set -e \
    && wget https://launchpad.net/duplicity/0.8-series/${DUPLICITY_VERSION}/+download/duplicity-${DUPLICITY_VERSION}.tar.gz \
    && wget https://launchpad.net/duplicity/0.8-series/${DUPLICITY_VERSION}/+download/duplicity-${DUPLICITY_VERSION}.tar.gz.sig \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver hkps.pool.sks-keyservers.net --receive-key 2F9532C8 E654E600 \
    && gpg --verify duplicity-${DUPLICITY_VERSION}.tar.gz.sig \
    && tar xzf duplicity-${DUPLICITY_VERSION}.tar.gz \
    && cd duplicity-${DUPLICITY_VERSION} \
    && pip3 --no-cache-dir install -r requirements.txt \
    && python setup.py install \
    && cd - \
    && rm -rf duplicity-${DUPLICITY_VERSION}/ duplicity-${DUPLICITY_VERSION}.tar.gz duplicity-${DUPLICITY_VERSION}.tar.gz.sig

RUN set -e \
    && wget https://sourceforge.net/projects/ftplicity/files/duply%20%28simple%20duplicity%29/2.2.x/duply_2.2.2.tgz/download -O - | tar xz \
    && cp duply_2.2.2/duply /usr/local/bin/duply \
    && chmod +x /usr/local/bin/duply \
    && rm -rf duply_2.2.2/ duply_2.2.2.tgz

RUN mkdir /backup /archive_dir

# ENTRYPOINT ["/usr/local/bin/duply"]
# CMD ["usage"]

CMD ["/bin/bash"]
