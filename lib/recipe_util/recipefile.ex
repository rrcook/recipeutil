defmodule RecipeUtil.File do
  def run(%{} = args \\ %{}) do
    source = Map.get(args, :source)
    dest = Map.get(args, :dest)

    with {:ok, file} <- File.open(source),
    data <- IO.binread(file, :eof),
     :ok <- File.close(file) do
      {:ok, recipe, _rest} = RecipeType.parse(data)
      # IO.inspect(recipe_type)
      recipe_bytes = RecipeType.generate(recipe)
      if (dest) do
        with {:ok, file} <- File.open(dest, [:write, :binary]) do
          IO.binwrite(file, recipe_bytes)
          File.close(file)
        end
      else
        IO.inspect(recipe)
      end
    end
  end
end
