# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.1.3 - 2019-05-22
### Added
- Add a changelog
- Add specs
- Add credits in README (https://github.com/guillaumebriday/jsonapi-scopes/commit/1f76b0ad822087a0305d102515946a756088d0c1)

### Changed
- `apply_filter` use the method `all` to generate an ActiveRecord collection.
- `apply_sort` has now optional params.

### Removed
- Remove 'attr_reader` on `filters`.