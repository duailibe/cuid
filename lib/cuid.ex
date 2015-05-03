defmodule Cuid do
  @moduledoc """
  Collision-resistant ids.
  """
  @block_size 4
  @base 36
  @discrete_values 1_679_615

  def new do
    "c" <> timestamp <> counter <> fingerprint <> random_block <> random_block
  end

  # TODO: use Agent to keep state
  defp counter do
    format 0
  end

  defp timestamp do
    {mega, uni, micro} = :os.timestamp
    (mega * 1_000_000 + uni) * 1_000 + div(micro, 100)
    |> format(@block_size * 2)
  end

  defp random_block do
    :random.uniform(@discrete_values)
    |> format
  end

  defp format(num, size \\ @block_size) do
    num
    |> Integer.to_string(@base)
    |> String.rjust(size, ?0)
    |> String.slice(-size..-1)
    |> String.downcase
  end

  defp fingerprint do
    padding = 2

    pid = String.to_integer(System.get_pid)

    hostname = to_char_list :net_adm.localhost
    hostid = Enum.sum(hostname) + Enum.count(hostname) + @base

    format(pid, padding) <> format(hostid, padding)
  end
end
