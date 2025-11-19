#!/bin/bash
set -eo pipefail

dir="$(dirname "$(readlink -f "$BASH_SOURCE")")"

image="$1"

PLONE_TEST_SLEEP=10
PLONE_TEST_TRIES=10

# Start Postgres
zname="relstorage-container-$RANDOM-$RANDOM"
zpull="$(docker pull postgres:12-alpine)"
zid="$(docker run -d --name "$zname" -e POSTGRES_USER=plone -e POSTGRES_PASSWORD=plone -e POSTGRES_DB=plone postgres:12-alpine)"

# Start Plone as RelStorage Client
pname="plone-container-$RANDOM-$RANDOM"
pid="$(docker run -d --name "$pname" --link=$zname:db -e RELSTORAGE_DSN="dbname='plone' user='plone' host='db' password='plone'" "$image")"

# Tear down
trap "docker rm -vf $pid $zid > /dev/null" EXIT

get() {
	docker run --rm -i \
		--link "$pname":plone \
		--entrypoint /app/bin/python \
		"$image" \
		-c "from urllib.request import urlopen; con = urlopen('$1'); print(con.read())"
}

get_auth() {
	docker run --rm -i \
		--link "$pname":plone \
		--entrypoint /app/bin/python \
		"$image" \
		-c "from urllib.request import urlopen, Request; request = Request('$1'); request.add_header('Authorization', 'Basic $2'); print(urlopen(request).read())"
}

. "$dir/../../retry.sh" --tries "$PLONE_TEST_TRIES" --sleep "$PLONE_TEST_SLEEP" get "http://plone:8080"

#!/bin/bash
set -eo pipefail

dir="$(dirname "$(readlink -f "$BASH_SOURCE")")"

image="$1"

PLONE_TEST_SLEEP=5
PLONE_TEST_TRIES=20

vname="/tmp/plone-data-$RANDOM-$RANDOM"
cname="plone-container-$RANDOM-$RANDOM"
vid="$(mkdir -p $vname)"
cid="$(docker run -d --user=$(id -u) -v $vname:/data --name $cname $image)"
trap "docker rm -vf $cid > /dev/null; rm -rf $vname > /dev/null" EXIT

get() {
        docker run --rm -i \
                --link "$cname":plone \
                --entrypoint /app/bin/python \
                "$image" \
                -c "from urllib.request import urlopen; con = urlopen('$1'); print(con.read())"
}

get_auth() {
        docker run --rm -i \
                --link "$cname":plone \
                --entrypoint /app/bin/python \
                "$image" \
                -c "from urllib.request import urlopen, Request; request = Request('$1'); request.add_header('Authorization', 'Basic $2'); print(urlopen(request).read())"
}


. "$dir/../../retry.sh" --tries "$PLONE_TEST_TRIES" --sleep "$PLONE_TEST_SLEEP" get "http://plone:8080"

# Plone is up and running
[[ "$(get 'http://plone:8080')" == *"Welcome to Plone!"* ]]

# Create a Plone site (classic)
[[ "$(get_auth 'http://plone:8080/@@ploneAddSite?distribution=classic' "$(echo -n 'admin:admin' | base64)")" == *"plone-overview.min.js"* ]]

# Create a Plone site (volto)
[[ "$(get_auth 'http://plone:8080/@@ploneAddSite?distribution=volto' "$(echo -n 'admin:admin' | base64)")" == *"plone-overview.min.js"* ]]