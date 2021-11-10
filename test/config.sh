#!/usr/bin/env bash
globalTests+=(
        utc
        no-hard-coded-passwords
        override-cmd
)

imageTests+=(
	[eeacms/plone-backend]='
		plone-basics
		plone-develop
		plone-site
		plone-addons
		plone-arbitrary-user
		plone-zeoclient
		plone-relstorage
	'
)

globalExcludeTests+=(

)
