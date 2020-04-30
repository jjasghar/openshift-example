# OpenShift Example

## Scope

This repo is designed for a simple way to deploy a `hello-world` application
to an OpenShift v4 environment.

This repo is inspired from this website: [https://nodejs.org/de/docs/guides/nodejs-docker-webapp/](https://nodejs.org/de/docs/guides/nodejs-docker-webapp/)

## Process

1. Clone down this repository
2. Login your OpenShift cluster

```bash
oc login --token=A_LARGE_TOKEN_HERE --server=https://c106-e.us-south.containers.cloud.ibm.com:30260
```

3. Create a project to deploy this to

```bash
oc new-project temp-hello-world
```

4. Create a new build strategy

```bash
oc new-build --strategy docker --binary --docker-image node:10 --name hello-world
```

5. Start the build

```bash
oc start-build hello-world --from-dir . --follow
```

6. Create the `app`

```bash
oc new-app temp-hello-world/hello-world:latest
```

7. Expose the `app` to the real world

```bash
oc expose svc/hello-world
```

8. Check the status/URL via

```bash
oc status
```

## Add a GitHub Webhook

Say you want to edit the "code" change it from `Hello World` to `Hello <event you are at>` adding a webhook is the way to go.

1. Click `Builds > Overview` scroll down to `Webhooks` copy (with secret) the GitHub hook. It may not respond, but try to `Paste` in another window to see that it works.

2. Open up your repository to the GitHub Webhooks. `Add Webhook` then paste the URL into `Payload URL` and change `Content type` to JSON. `Add webhook` and confirm you have the GREEN checkmark.


## License & Authors

If you would like to see the detailed LICENSE click [here](LICENSE).

- Author: JJ Asghar <jjasghar@gmail.com>

```text
Copyright:: 2020- JJ Asghar

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
