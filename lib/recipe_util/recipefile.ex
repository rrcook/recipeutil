defmodule RecipeUtil.File do

  @subst_map  %{
    "Body" =>
    "This is line 1" <> << 0x0D, 0x0A, 0x20 >> <>
    "This is line 2" <> << 0x0D, 0x0A, 0x20 >> <>
    "This is a longer line 3",
    "HL" =>
    "This is a headline test",
    "NextHL" =>
    "Go to next page"
  }

  def run(%{:page_setup => true} = args) do
    source = Map.get(args, :source)
    dest = Map.get(args, :dest)

    with {:ok, data} <- File.read(source) do
      data_with_page_info = NewsHeadlines.page_setup(data, 1, 1)
      if (dest) do
        File.write!(dest, data_with_page_info)
      else
        IO.inspect(data_with_page_info)
      end
    end
  end

  def run(%{} = args) do
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
