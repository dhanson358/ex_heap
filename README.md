# ExHeap

ExHeap is a very thin wrapper for the [Heap Analytics Server Side API](https://developers.heap.io/reference#track-1)

It is meant to help manage the API headers, URLs, etc, but mostly pass through the data unedited.

Basic usage:

```elixir
iex> ExHeap.track("user@example.com", "My Heap Event", %{"extra_id" => 1234})
{:ok, %HTTPoison.Response{...}}

iex> ExHeap.add_user_properties("user@example.com", %{"company_name" => "MegaCorp"})
{:ok, %HTTPoison.Response{...}}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_heap` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_heap, "~> 0.1.0"}
  ]
end
```

Then configure the `ex_heap` app per environment like so:

```elixir
config :ex_heap,
  app_id: "123456789", # required
  httpoison: [recv_timeout: 5000, timeout: 8000] # optional
```

You may also use environment variables:

``` elixir
config :ex_heap,
  app_id: {:system, "HEAP_APP_ID"}
```


## License

- Stripy: See LICENSE file.