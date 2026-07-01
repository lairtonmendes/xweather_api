## [Unreleased]

## [0.2.0]

- Support per-request credentials: `client_id:`/`client_secret:` passed to a request now
  override the globally configured values, so a single process can query the API on behalf
  of multiple subscriptions. Global configuration remains the default when they are omitted.

## [0.1.0] - 2025-05-22

- Initial release
