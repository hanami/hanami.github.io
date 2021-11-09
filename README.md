# Hanami website

## Setup

### Requirements

  * Ruby 2+
  * Bundler (`gem install bundler`)

### Steps

```shell
% git clone git@github.com:hanami/hanami.github.io.git
% cd hanami.github.io
% bundle
```

## Command line

```shell
% bin/site help

Usage:
  bin/site [command]
Available commands:
  develop - Start the local server to develop the site
  build   - Build the site locally
  help    - Print this help
```

NOTE: There is an issue in which invoking `site` command with specified
current directory, `./bin/site` won't publish the site correctly. Please
invoke without `./`

## Production deployment

The deployment is automated with Netifly.
