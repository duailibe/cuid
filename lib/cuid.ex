defmodule Cuid do
  use GenServer

  @block_size 4
  @base 36
  @discrete_values 1_679_616

  @moduledoc """
  Collision-resistant ids.

  Usage:

    # Start the generator
    {:ok, generator} = Cuid.start_link

    # Generate a new CUID
    Cuid.generate(generator)
  """

  @doc """
  Starts a new generator.

  Returns either `{:ok, pid}` or `{:error, reason}`
  """
  @spec start_link(process_opts :: list() | nil) :: {:ok, pid} | {:error, term}
  def start_link(process_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, process_opts)
  end

  @doc """
  Generates and returns a new CUID.
  """
  @spec generate(generator :: pid) :: String.t
  def generate(generator) do
    GenServer.call(generator, :generate)
  end

  ### Server callbacks

  def init(:ok) do
    {:ok, %{:fingerprint => get_fingerprint, :count => 0}}
  end

  def handle_call(:generate, _, %{:fingerprint => fingerprint, :count => count} = state) do
    cuid = Enum.join([
      "c", timestamp, counter(count), fingerprint, random_block, random_block
    ]) |> String.downcase

    {:reply, cuid, %{state | :count => count + 1}}
  end

  # Returns the current count number as a 4-digit base-36 string
  @spec counter(num :: number) :: String.t
  defp counter(num) do
    num
    |> Integer.to_string(@base)
    |> String.rjust(@block_size, ?0)
  end

  # Returns the time as a 4-digit base-36 string
  @spec timestamp() :: String.t
  defp timestamp do
    {mega, uni, micro} = :os.timestamp
    rem((mega * 1_000_000 + uni) * 1_000_000 + micro, @discrete_values * @discrete_values)
    |> Integer.to_string @base
  end

  # Returns a random 4-digit base-36 string
  @spec random_block() :: String.t
  defp random_block do
    :random.uniform(@discrete_values - 1)
    |> Integer.to_string(@base)
    |> String.rjust(@block_size, ?0)
  end

  @operator @base * @base

  # Returns the fingerprint of the host as a 4-digit base-36 string
  # It consists of the current OS process ID and the hostname
  @spec get_fingerprint() :: String.t
  defp get_fingerprint do
    pid = rem(String.to_integer(System.get_pid), @operator) * @operator

    hostname = to_char_list :net_adm.localhost
    hostid = rem(Enum.sum(hostname) + Enum.count(hostname) + @base, @operator)

    pid + hostid
    |> Integer.to_string(@base)
  end
end
