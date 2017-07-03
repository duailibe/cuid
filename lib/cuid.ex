defmodule Cuid do
  @moduledoc """
  Collision-resistant ids.

  Usage:

      # Start the generator
      {:ok, generator} = Cuid.start_link

      # Generate a new CUID
      Cuid.generate(generator)
  """

  @doc """
  Generates and returns a new CUID.
  """
  @spec generate(generator :: pid) :: String.t
  def generate(generator) do
    GenServer.call(generator, :generate)
  end

  @doc """
  Generates and returns a new Slug
  """
  @spec slug(generator :: pid) :: String.t
  def slug(generator) do
    GenServer.call(generator, :generate_slug)
  end

  use GenServer

  @doc """
  Starts a new generator.
  """
  def start_link(process_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, process_opts)
  end

  ## Server callbacks

  def init(:ok) do
    {:ok, %{:fingerprint => get_fingerprint, :count => 0}}
  end

  def handle_call(:generate, _, %{:fingerprint => fingerprint, :count => count} = state) do
    cuid = Enum.join([
      "c", timestamp, format_counter(count), fingerprint, random_block, random_block
    ]) |> String.downcase

    {:reply, cuid, %{state | :count => count + 1}}
  end

  def handle_call(:generate_slug, _, %{:fingerprint => fingerprint, :count => count} = state) do
    slug = Enum.join([
      slice(timestamp, -2),
      slice(format_counter(count), -4),
      slice(fingerprint, 0..1),
      slice(fingerprint, -1),
      slice(random_block, -2)
    ]) |> String.downcase

    {:reply, slug, %{state | :count => count + 1}}
  end

  ## Helpers

  @block_size 4
  @base 36

  defp format_counter(num) do
    num
    |> Integer.to_string(@base)
    |> String.rjust(@block_size, ?0)
  end

  @discrete_values 1_679_616

  defp timestamp do
    {mega, uni, micro} = :os.timestamp
    rem((mega * 1_000_000 + uni) * 1_000_000 + micro, @discrete_values * @discrete_values)
    |> Integer.to_string @base
  end

  defp random_block do
    :random.uniform(@discrete_values - 1)
    |> Integer.to_string(@base)
    |> String.rjust(@block_size, ?0)
  end

  @operator @base * @base

  defp get_fingerprint do
    pid = rem(String.to_integer(System.get_pid), @operator) * @operator

    hostname = to_char_list :net_adm.localhost
    hostid = rem(Enum.sum(hostname) + Enum.count(hostname) + @base, @operator)

    pid + hostid
    |> Integer.to_string(@base)
  end

  defp slice(str, beginIndex) when beginIndex >= 0 do
    String.slice(str, beginIndex, String.length(str))
  end

  defp slice(str, beginIndex) when beginIndex < 0 do
    String.slice(str, beginIndex, String.length(str) + beginIndex)
  end
end
