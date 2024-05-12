# With Makefile - Control Multiple Environments Docker Image Release and Versioning

Nest.js team have an example in their official examples as [With Docker - Multiple Deployment Environments](https://github.com/vercel/next.js/tree/canary/examples/with-docker-multi-env), which managed in a [Makefile](https://github.com/vercel/next.js/blob/canary/examples/with-docker-multi-env/Makefile).

This example pushed it further, not only load different environments, but also make `Makefile as an Orchestra`, let it control every step of a Next.js project docker image release.

## Pain-point and Thinking

When managing multiple environments deployment, it's easy to load the wrong configuration.

To make `version verification` easier, a `Consistent Tag` should be injected to all the `outputs` during the build phase.

A `Tag` should reveals:

1. The public version tag
2. The env file loaded for the build
3. The git commit hash code upon the build

The tag should be logged in a `consistent` manner:

1. Printed in the terminal output, during build a docker image
2. Printed in the backend log file, once the node service launched
3. Displayed in the browser console or a landing page, once html page fetched

### For Example

The current project `package.json` looks like below:

```json
"name": "x-app",
"version": "1.0.9",
```

#### After Build Phase

- `package.json` version field will be auto increased.

```json
"version": "1.1.0",
```

- Output from shell:

```bash
# docker image
x-app-production     v1.1.0       xxx     Less than a second ago      152MB
```

#### After Deployed

- Backend

```js
// log in node server
 ▲ Next.js 14.2.3
  - Local:        http://localhost:3000
  - Network:      http://0.0.0.0:3000

 ✓ Starting...
 🚀 version: v1.1.0-75a44a7-production
 ✓ Ready in 799ms
```

- Frontend

```js
// console / on a page
Release: v1.1.0-75a44a7-production
```

By seeing those, we can announce confidently:

- `x-app project v1.1.0 production` is ready 🎉

## How to use

Clone the project and install the dependencies

```bash
# choose your favorite package manager, we use pnpm here
pnpm install
```

- Enter the values in the `.env.development`, `.env.staging`, `.env.production` files to be used for each environments.

Check all available commands by simply run `make` command on the root path of the project:

```bash
make
```

- You might need to install the make tool for non-unix based OS. [Make for Windows](https://gnuwin32.sourceforge.net/packages/make.htm)

### For Production Deployment

```bash
# build a docker image
make build

# push the docker image to registry
# just `make push` if DOCKER_ACCOUNT in shell env
make push DOCKER_ACCOUNT=<YOUR_DOCKER_ACCOUNT>

# git commit the changes
make commit

# shortcut for run the above commands in sequence
make all
```

### For Staging Deployment

```bash
make <command> NODE_ENV=staging
```

### For Development Deployment

```bash
make <command> NODE_ENV=development
```

### For Local Development

```bash
make dev
```
