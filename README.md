# Plone 6 (pip) based with RelStorage, RestAPI, Memcached, Graylog, Sentry support (and more)

[![5.x](https://ci.eionet.europa.eu/buildStatus/icon?job=plone/plone-backend/5.x&subject=5.x)](https://ci.eionet.europa.eu/blue/organizations/jenkins/plone%2Fplone-backend/activity/)
[![6.x](https://ci.eionet.europa.eu/buildStatus/icon?job=plone/plone-backend/master&subject=6.x)](https://ci.eionet.europa.eu/blue/organizations/jenkins/plone%2Fplone-backend/activity/)
[![Release](https://img.shields.io/docker/v/eeacms/plone-backend?sort=semver)](https://hub.docker.com/r/eeacms/plone-backend/tags)

Plone 6 (pip) with built-in support for:
* RelStorage
* RestAPI
* LDAP
* Memcached
* Graylog
* Sentry

This image is generic, thus you can obviously re-use it within your own projects.

See [5.x](https://github.com/eea/plone-backend/tree/5.x) branch for Plone 5.

## Releases

* `github.com:` [eea/plone-backend/releases](https://github.com/eea/plone-backend/releases)

## Base docker image

* `hub.docker.com:` [eeacms/plone-backend](https://hub.docker.com/r/eeacms/plone-backend/)

## Source code

* `github.com:` [eea/plone-backend](http://github.com/eea/plone-backend)

## Simple Usage

### RestAPI

    $ docker run -it --rm -p 8080:8080 -e SITE=Plone eeacms/plone-backend

    $ curl -i http://localhost:8080/Plone/++api++ -H 'Accept: application/json'

### ZEO

See `plone/plone-backend` [ZEO Server](https://6.docs.plone.org/install/containers/images/backend.html?highlight=relstorage#zeo-variables)

### RelStorage (PostgreSQL)

See `plone/plone-backend` [Relational Database](https://6.docs.plone.org/install/containers/images/backend.html?highlight=relstorage#relational-database-variables)


Now, ask for http://localhost:8080/ in your workstation web browser and add a Plone site (default credentials `admin:admin`).

See more about Plone at [plone-backend](https://6.docs.plone.org/install/containers/images/backend.html)

## Extending this image

For this you'll have to provide the following custom files:

* `requirements.txt`
* `constraints.txt`
* `Dockerfile`

Below is an example on how to build a custom version of Plone with some add-ons based on this image:

**requirements.txt**:

    eea.facetednavigation
    collective.elasticsearch
    collective.taxonomy

**constraints.txt**

    eea.facetednavigation==16.0a1
    collective.elasticsearch==5.0.0
    collective.taxonomy==3.1


**Dockerfile**:

    FROM eeacms/plone-backend

    COPY requirements.txt constraints.txt /app
    RUN pip install -r requirements.txt -c constraints.txt

and then run

    $ docker build -t eeacms/custom-backend .

See for example [EEA Main Website backend (Plone 6)](https://github.com/eea/eea-website-backend)

## Supported environment variables

See `plone/plone-backend` [Configuration Variables](https://6.docs.plone.org/install/containers/images/backend.html#configuration-variables)

### Graylog

* `GRAYLOG` Configure zope inside container to send logs to Graylog. Default `logcentral.eea.europa.eu:12201` (e.g.: `GRAYLOG=logs.example.com:12201`)
* `GRAYLOG_FACILITY` Custom GrayLog facility. Default `eea.docker.plone` (e.g.: `GRAYLOG_FACILITY=staging.example.com`)

### Sentry

* `SENTRY_DSN` Send python tracebacks to sentry.io or your custom Sentry installation (e.g.: SENTRY_DSN=https://<public_key>:<secret_key>@sentry.example.com)
* `SENTRY_SITE`, `SERVER_NAME` Add site tag to Sentry logs (e.g.: `SENTRY_SITE=foo.example.com`)
* `SENTRY_RELEASE` Add release tag to Sentry logs (e.g.: `SENTRY_RELEASE=5.1.5-34`)
* `SENTRY_ENVIRONMENT` Add environment tag to Sentry logs. Leave empty to automatically get it from `rancher-metadata` (e.g.: `SENTRY_ENVIRONMENT=staging`)

## Develop

See [develop](https://github.com/eea/plone-backend/tree/master/develop)

## Release

See [release](https://github.com/eea/plone-backend/tree/master/RELEASE.md)

## Copyright and license

The Initial Owner of the Original Code is European Environment Agency (EEA).
All Rights Reserved.

The Original Code is free software;
you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any later
version.

## Funding

[European Environment Agency (EU)](http://eea.europa.eu)
