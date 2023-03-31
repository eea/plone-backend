FROM plone/plone-backend:6.0.2 as base
FROM base as builder

ENV PLONE_VERSION=6.0.2 \
    GRAYLOG=logcentral.eea.europa.eu:12201 \
    GRAYLOG_FACILITY=plone-backend \
    MEMCACHE_SERVER=memcached:11211 \
    PROFILES=eea.kitkat:default

RUN apt-get update \
    && buildDeps="build-essential libldap2-dev libsasl2-dev" \
    && apt-get install -y --no-install-recommends $buildDeps\
    && rm -rf /var/lib/apt/lists/* /usr/share/doc

COPY /etc/zope.ini /app/etc/
COPY requirements.txt constraints.txt /app/
RUN pip wheel -r requirements.txt -c constraints.txt -c https://dist.plone.org/release/$PLONE_VERSION/constraints.txt --wheel-dir=/wheelhouse ${PIP_PARAMS}

FROM base

ENV PLONE_VERSION=6.0.2 \
    GRAYLOG=logcentral.eea.europa.eu:12201 \
    GRAYLOG_FACILITY=plone-backend \
    MEMCACHE_SERVER=memcached:11211 \
    PROFILES=eea.kitkat:default

COPY --from=builder /wheelhouse /wheelhouse

RUN ./bin/pip install --no-index --no-deps ${PIP_PARAMS} /wheelhouse/* \
    && find /app -not -user plone -exec chown plone:plone {} \+

ENTRYPOINT [ "/app/docker-entrypoint.sh" ]
CMD ["start"]
