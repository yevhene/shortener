# Shortener

App is deployed to Gigalixir [straight-profuse-racer.gigalixirapp.com](https://straight-profuse-racer.gigalixirapp.com/)

## Setup

1. `mix.deps get` - install dependencies
2. `mix ecto.setup` - setup database
3. `npm install --prefix assets` - install assets dependencies

## Start

```
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Deploy to Gigalixir

```
git push gigalixir master
```
