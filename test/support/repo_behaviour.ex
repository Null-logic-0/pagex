defmodule Pagex.RepoBehaviour do
  @callback all(Ecto.Query.t()) :: list()
  @callback one(Ecto.Query.t()) :: any()
end
