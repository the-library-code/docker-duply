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
    && for key in E654E600 \
    ; do \
        gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
        gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
        gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
    done \
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

RUN mkdir -p /backup /archive_dir /root/.gnupg /root/.ssh \
    && chmod 700 /root/.gnupg /root/.ssh \
    && echo 'no-tty\nuse-agent\npinentry-mode loopback' >> /root/.gnupg/gpg.conf \
    && echo 'allow-loopback-pinentry' >> /root/.gnupg/gpg-agent.conf

# ENTRYPOINT ["/usr/local/bin/duply"]
# CMD ["usage"]

CMD ["/bin/bash"]
