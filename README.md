prospectus_travis
=========

[![Gem Version](https://img.shields.io/gem/v/prospectus_travis.svg)](https://rubygems.org/gems/prospectus_travis)
[![Build Status](https://img.shields.io/travis/com/akerl/prospectus_travis.svg)](https://travis-ci.com/akerl/prospectus_travis)
[![Coverage Status](https://img.shields.io/codecov/c/github/akerl/prospectus_travis.svg)](https://codecov.io/github/akerl/prospectus_travis)
[![Code Quality](https://img.shields.io/codacy/c5623564a4034ece993510d28edb19de.svg)](https://www.codacy.com/app/akerl/prospectus_travis)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

[Prospectus](https://github.com/akerl/prospectus) helpers for checking travis build status

## Usage

Add the following 2 lines to the .prospectus:

```
## Add this at the top
Prospectus.extra_dep('file', 'prospectus_travis')

## Add this inside your item that has a build
extend ProspectusTravis.build('ORG/REPO')
```

## Installation

    gem install prospectus_travis

## License

prospectus_travis is released under the MIT License. See the bundled LICENSE file for details.

