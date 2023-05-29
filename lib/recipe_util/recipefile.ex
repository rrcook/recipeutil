defmodule RecipeUtil.File do

  @subst_map  %{
    "Body" =>
    "This is line 1" <> << 0x0D, 0x0A >> <>
    "This is line 2" <> << 0x0D, 0x0A >> <>
    "This is a longer line 3",
    "HL" =>
    "Richard is a l33t haX0r",
    "NextHL" =>
    "NEWSFLASH! Elixir Is Fun!"
  }

  def run(%{} = args \\ %{}) do
    source = Map.get(args, :source)
    dest = Map.get(args, :dest)

    with {:ok, data} <- File.read(source) do
      {:ok, recipe, _rest} = RecipeType.parse(data, @subst_map)
      # IO.inspect(recipe_type)
      recipe_bytes = RecipeType.generate(recipe)
      if (dest) do
        File.write!(dest, recipe_bytes)
      else
        IO.inspect(recipe)
      end
    end
  end
end
