### App

App with interaction with Marvel API.

App is deployed and running on Gigalixir ?

### Stack

The solution was built using:

- Elixir 1.14
- Erlang 25.1
- Phoenix 1.7.10
- LiveView 0.19
- PostgreSQL

### Installation & Setup

It requires you to have the same stack installed. If you are using `bash` you need ro run:

```bash
touch .bash_env

# use your credentials
export MARVEL_API_PUBLIC_KEY="MARVEL_API_PUBLIC_KEY"
export MARVEL_API_PRIVATE_KEY="MARVEL_API_PRIVATE_KEY"
export POSTGRES_USER="POSTGRES_USER"
export POSTGRES_PASSWORD="POSTGRES_PASSWORD"
export POSTGRES_HOST="POSTGRES_HOST"


source .bash_env
```

If you are using `fish` like me, you need to run:

```bash
touce .fish_env

# use your credentials
set -x POSTGRES_USER postgres
set -x POSTGRES_PASSWORD postgres
set -x POSTGRES_HOST localhost
set -x MARVEL_API_PUBLIC_KEY public_key
set -x MARVEL_API_PRIVATE_KEY private_key

source .fish_env
```

Both commands will set the env variables for MARVEL_API_PUBLIC_KEY, MARVEL_API_PRIVATE_KEY, POSTGRES_USER, POSTGRES_PASSWORD and POSTGRES_HOST to later be used on test and dev env.

Once env variables are set is possible to setup the DB for both envs.

```bash
mix deps.get
mix compile
mix ecto.create; mix ecto.migrate
MIX_ENV=test mix ecto.create; mix ecto.migrate
```

### Running the app

```bash
iex -S mix phx.server
```

It will run the app and also open the iex console. If you do not wanna the iex console just run `mix phx.server`

Server must be available on http://localhost:4000/characters

### Running test

Tests were developed using the default ExUnit framework and can be used by running:

```
mix test
```

### Formating and code styles


```bash
mix credo; mix format; mix dialyzer;
```