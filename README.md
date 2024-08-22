# selfservice

selfservice is a CLI tool to make using the [Self Service API](https://self-service.isv.ci/api) much easier.

## Commands

### Auth
This command will authenticate against the Auth Service, returning a valid token that can be used for later commands.

It requires a API token as an argument and will print an `export` command that will set the AUTH_TOKEN environment variable.

```bash
$ selfservice auth xoxp-504313...
export AUTH_TOKEN=eyJhbGci0i...
```

### List

This lists the environments that are available to you.

```bash
$ selfservice list | jq .
[
  {
    "id": 136,
    "name": null,
    "credentials": ...,
    "nonce": "e4d21c6e-9f8e-4dba-8ca9-f7e33f1ac140",
    "status": "success",
    "created_at": "2020-10-28T18:28:46.131Z",
    "updated_at": "2020-10-28T18:28:46.131Z",
    "created_by": "pwall@pivotal.io",
    "environment_type": "isv_ci_tas_srt_2_10",
    "expiry": null,
    "released_by": null,
    "released_at": null,
    "pool_label": "TAS SRT 2.10"
  }
]
```

### Get

This gets the details for a single environment.

It requires the Self Service environment ID as an argument.

```bash
$ selfservice get 136 | jq .
{
  "id": 136,
  "name": null,
  "credentials": ...,
  "nonce": "e4d21c6e-9f8e-4dba-8ca9-f7e33f1ac140",
  "status": "success",
  "created_at": "2020-10-28T18:28:46.131Z",
  "updated_at": "2020-10-28T18:28:46.131Z",
  "created_by": "pwall@pivotal.io",
  "environment_type": "isv_ci_tas_srt_2_10",
  "expiry": null,
  "released_by": null,
  "released_at": null,
  "pool_label": "TAS SRT 2.10"
}
```

### Types

This gets the types of environments that can be claimed by this user.

```bash
$ selfservice types  | jq .
[
  {
    "name": "isv_ci_tas_srt_2_10",
    "type": "tas",
    "version": "2.10"
  }
]
```

### Claim

This claims a new environment, returning immediately. The environment might not be usable, so subsequent calls with `selfservice get` would be required.

It requires an environment type name as an argument.

```bash
$ selfservice claim isv_ci_tas_srt_2_10 | jq .
{
  "id": 139,
  "created_at": "2020-10-28T18:42:27.546Z",
  "updated_at": "2020-10-28T18:42:27.546Z",
  "released_at": null,
  "status": "pending",
  "credentials": null,
  "created_by": "pwall@pivotal.io",
  "released_by": null,
  "expiry": null,
  "environment_type": "isv_ci_tas_srt_2_10",
  "url": "https://self-service.isv.ci/environments/139.json"
}
```

### Claim and Wait

This claims a new environment and then periodically gets updates until the environment is available to use.

It requires an environment type name as an argument.

```bash
$ selfservice claimAndWait isv_ci_tas_srt_2_10 | jq .
{
  "id": 138,
  "name": "first",
  "credentials": "{\"name\":\"first\",\"password\":\"foo\"}",
  "nonce": null,
  "status": "success",
  "created_at": "2020-10-28T18:41:48.384Z",
  "updated_at": "2020-10-28T18:41:49.712Z",
  "created_by": "pwall@pivotal.io",
  "environment_type": "isv_ci_tas_srt_2_10",
  "expiry": "2020-10-29T18:41:49.000Z",
  "released_by": null,
  "released_at": null,
  "pool_label": "TAS SRT 2.10"
}
```

### Release

This releases the environment back to Self Service. The environment will be destroyed and cannot be recovered.

It requires the Self Service environment ID as an argument.

```bash
$ selfservice release 145 | jq .
{
  "id": 145,
  "created_at": "2020-10-28T18:51:56.837Z",
  "updated_at": "2020-10-28T18:54:26.202Z",
  "released_at": "2020-10-28T18:54:26.201Z",
  "status": "releasing",
  "credentials": "{\"name\":\"first\",\"password\":\"foo\"}",
  "created_by": "pwall@pivotal.io",
  "released_by": "pwall@pivotal.io",
  "expiry": "2020-10-29T18:51:57.000Z",
  "environment_type": "isv_ci_tas_srt_2_7",
  "url": "https://self-service.isv.ci/environments/145.json"
}
```

## Variables

The selfservice CLI uses three environment variables:

* `AUTH_TOKEN` - This is the token retrieved by running `selfservice auth`. It must be set for all other commands.
* `AUTH_URL` - This is the URL for the Auth service, used only when fetching Auth tokens. It is https://auth.isv.ci by default.
* `SELF_SERVICE_URL` - This is the URL for Self Service. It is https://self-service.isv.ci by default.

## Notes

### Finding your API Token

To get a valid API token for authentication:

1. Visit https://auth.isv.ci
1. Click on "Sign in with Broadcom"
1. Login into [support portal](https://login.broadcom.com/) using broadcom support credentials
1. Scroll to the bottom of the profile page
1. Click on the "Token for API Access" button
