# Demo

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Run `docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=dbpassword postgres` to start the database
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000/albums`](http://localhost:4000/albums) from your browser.

## Resources

### add track & performers

- [dynamically adding and removing inputs official docs](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html#inputs_for/1-dynamically-adding-and-removing-inputs)