# Hound-SCSS

[![Build Status](https://circleci.com/gh/thoughtbot/hound-scss/tree/master.svg?style=svg)](https://circleci.com/gh/thoughtbot/hound-scss/tree/master)

SCSS review service for Hound. Backed by [SCSS-Lint](https://github.com/brigade/scss-lint).

For more information on the SCSS configuration options, please refer to the [scss-lint documentation](https://github.com/brigade/scss-lint/blob/master/lib/scss_lint/linter/README.md).

The service consists of a simple job class that uses Redis as a queue to
coordinate work with Hound.

## Getting Started

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % ./bin/setup
