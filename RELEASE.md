## Release

### Automatic release using Jenkins

#### Release flow

The release flow on Plone projects is split in 2 Jenkins jobs:

* A job that runs on every commit on master and creates a production ready GitHub release and tag
* A job that runs on every new tag (including the one created in the first job):
    * A new Docker image is built and released automatically on [DockerHub](https://hub.docker.com/r/eeacms/plone-backend) with the release tag.

#### How to start a Production release

*  The automatic release is started by creating a [Pull Request](../../compare/master...develop) from `develop` to `master`. The pull request status checks correlated to the branch and PR Jenkins jobs need to be processed successfully. 1 review from a github user with rights is mandatory.
* It runs on every commit on `master` branch, which is protected from direct commits, only allowing pull request merge commits.
* The automatic release is done by [Jenkins](https://ci.eionet.europa.eu). The status of the release job can be seen both in the `README.md` badges and the green check/red cross/yellow circle near the last commit information. If you click on the icon, you will have the list of checks that were run. The `continuous-integration/jenkins/branch` link goes to the Jenkins job execution webpage.
* Automated release scripts are located in the `eeacms/gitflow` docker image.

## Production

We use [Docker](https://www.docker.com/), [Rancher](https://rancher.com/) and [Jenkins](https://jenkins.io/) to deploy this application in production.
