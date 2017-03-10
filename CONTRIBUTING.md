# Contributing

First, thank you for contributing!

We love pull requests from everyone. By participating in this project, you
agree to abide by the thoughtbot [code of conduct].

[code of conduct]: https://thoughtbot.com/open-source-code-of-conduct

Here are a few technical guidelines to follow:

1. Open an [issue][issues] to discuss a new feature.
1. Write tests.
1. Make sure the entire test suite passes locally and on CI.
1. Open a Pull Request.
1. [Squash your commits][squash] after receiving feedback.
1. Party!

[issues]: https://github.com/houndci/hound/issues
[squash]: https://github.com/thoughtbot/guides/tree/master/protocol/git#write-a-feature

## Configure Hound Linters on Your Local Development Environment


After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

```sh
% bin/setup
```
## Linters
### Writing a Linter

See Hound's [CONTRIBUTING] documentation for further details.

[CONTRIBUTING]: https://github.com/houndci/hound/blob/master/CONTRIBUTING.md#writing-a-linter

## Deploying
If you have previously run the `bin/setup` script, you can deploy to staging
and production with:

```sh
% bin/deploy staging
% bin/deploy production
```

## Contributor License Agreement

If you submit a Contribution to this application's source code, you hereby grant
to thoughtbot, inc. a worldwide, royalty-free, exclusive, perpetual and
irrevocable license, with the right to grant or transfer an unlimited number of
non-exclusive licenses or sublicenses to third parties, under the Copyright
covering the Contribution to use the Contribution by all means, including but
not limited to:

* to publish the Contribution,
* to modify the Contribution, to prepare Derivative Works based upon or
  containing the Contribution and to combine the Contribution with other
  software code,
* to reproduce the Contribution in original or modified form,
* to distribute, to make the Contribution available to the public, display and
  publicly perform the Contribution in original or modified form.
