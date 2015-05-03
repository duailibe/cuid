cuid
====

Collision-resistant ids optimized for horizontal scaling and sequential lookup performance,
written in Elixir.

For full rationale behind CUIDs refer to the [main project site](http://usecuid.org).


### Usage

Add Cuid as a dependency in your `mix.exs` file:

```elixir
    defp deps do:
        [{:cuid, "~> 0.1.0"}]
    end
```

Run `mix deps.get` to fetch and compile Cuid. It works as a process

```elixir
    {:ok, pid} = Cuid.start_link
    Cuid.generate(pid)  # => ch72gsb320000udocl363eofy
```

Each CUID is made by the following groups: `c - h72gsb32 - 0000 - udoc - l363eofy`

* `c` identifies this as a cuid, and allows you to use it in html entity ids. The fixed value helps keep the ids sequential.
* `h72gsb32` is a timestamp
* `0000` is a counter
* `udoc` is a fingerprint. The first two characters are based on the process ID and the next two are based on the hostname. This is the same method used in the [Node implementation](https://github.com/ericelliott/cuid/blob/master/src/node-fingerprint.js)
* `l363eofy` random (uses `:random.uniform`)


### TODOs

* Optimize (it takes 15s to run 200000 generations in my MBP)


### Credit

* Lucas Duailibe
* Eric Elliott (author of [original JavaScript version](http://github.com/ericelliott/cuid))
