FROM plone/plone-backend:6.0.15 as base
FROM base as builder

ENV PLONE_VERSION=6.0.15 \
    GRAYLOG=logcentral.eea.europa.eu:12201 \
    GRAYLOG_FACILITY=plone-backend \
    MEMCACHE_SERVER=memcached:11211 \
    RELSTORAGE_BLOB_CACHE_SIZE=2000mb \
    ZODB_CACHE_SIZE=250000 \
    ZOPE_FORM_MEMORY_LIMIT=250MB \
    PROFILES=eea.kitkat:default

RUN apt-get update \
    && buildDeps="build-essential libldap2-dev libsasl2-dev" \
    && apt-get install -y --no-install-recommends $buildDeps\
    && rm -rf /var/lib/apt/lists/* /usr/share/doc

COPY requirements.txt constraints.txt /app/
RUN pip wheel -r requirements.txt -c constraints.txt -c https://dist.plone.org/release/$PLONE_VERSION/constraints.txt --wheel-dir=/wheelhouse

FROM base

ENV PLONE_VERSION=6.0.15 \
    GRAYLOG=logcentral.eea.europa.eu:12201 \
    GRAYLOG_FACILITY=plone-backend \
    MEMCACHE_SERVER=memcached:11211 \
    RELSTORAGE_BLOB_CACHE_SIZE=2000mb \
    ZODB_CACHE_SIZE=250000 \
    ZOPE_FORM_MEMORY_LIMIT=250MB \
    PROFILES=eea.kitkat:default

COPY /etc/zope.ini /app/etc/
COPY --from=builder /wheelhouse /wheelhouse

RUN ./bin/pip install --no-index --no-deps /wheelhouse/* \
    && find /app -not -user plone -exec chown plone:plone {} \+

ENTRYPOINT [ "/app/docker-entrypoint.sh" ]
CMD ["start"]
