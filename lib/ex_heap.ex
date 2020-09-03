defmodule ExHeap do
  @moduledoc """
  ExHeap is a small wrapper for sending
  tracking and user data to Heap Analytic's Server-Side API.

  It takes care of forming the requests, headers, etc,
  but mostly lets you pass through your data untouched.

  Basic usage:

    ```elixir
    iex> ExHeap.track("user@example.com", "My Heap Event", %{"extra_id" => 1234})
    {:ok, %HTTPoison.Response{...}}

    iex> ExHeap.add_user_properties("user@example.com", %{"company_name" => "MegaCorp"})
    {:ok, %HTTPoison.Response{...}}
    ```

  """

  @root_url "https://heapanalytics.com/api"

  @spec track(any, any, any) ::
          {:error, HTTPoison.Error.t()}
          | {:ok,
             %{
               :__struct__ => HTTPoison.AsyncResponse | HTTPoison.Response,
               optional(:body) => any,
               optional(:headers) => [any],
               optional(:id) => reference,
               optional(:request) => HTTPoison.Request.t(),
               optional(:request_url) => any,
               optional(:status_code) => integer
             }}
  @doc """
  Track a user event

  https://developers.heap.io/reference#track-1

    * `identity` - string to identify the user (probably an email)
    * `event` - event name to pass to Heap
    * `properties` - arbitrary map of key/value pairs to annotate event

  ## Examples
    iex> ExHeap.track("user@example.com","My Event")
    {:ok, %HTTPoison.Response{...}}

    iex> ExHeap.track("user@example.com","My Event", %{"custom_property" => "foo"})
    {:ok, %HTTPoison.Response{...}}

  """
  def track(identity, event, properties \\ %{}) do
    %{
      "app_id" => get_config!(:app_id),
      "events" => [
        %{
          "identity" => identity,
          "timestamp" => "here",
          "event" => event,
          "properties" => properties
        }
      ]
    }
    |> post(track_url())
  end

  @doc """
  Assign customer properties to a user

  https://developers.heap.io/reference#add-user-properties

    * `identity` - string to identify the user (probably an email)
    * `properties` - arbitrary map of key/value pairs enrich user data

  ## Examples
    iex> ExHeap.add_user_properties("user@example.com", %{"key" => "value"})
    {:ok, %HTTPoison.Response{...}}

  """
  def add_user_properties(identity, properties \\ %{}) do
    %{
      "app_id" => get_config!(:app_id),
      "identity" => identity,
      "properties" => properties
    }
    |> post(add_user_properties_url())
  end

  defp track_url(), do: "#{@root_url}/track"
  defp add_user_properties_url(), do: "#{@root_url}/add_user_properties"

  defp post(data, url) do
    token = get_config!(:token)

    headers =
      %{
        "Authorization" => "Bearer #{token}",
        "Content-type" => "application/json"
      }
      |> Map.to_list()

    options = Application.get_env(:ex_heap, :httpoison, [])

    HTTPoison.request(:post, url, data, headers, options)
  end

  defp get_config(key, default \\ nil) when is_atom(key) do
    case Application.fetch_env(:stripy, key) do
      {:ok, {:system, env_var}} -> System.get_env(env_var)
      {:ok, value} -> value
      :error -> default
    end
  end

  defp get_config!(key) do
    get_config(key) || raise "ex_unit config #{key} is required"
  end
end
