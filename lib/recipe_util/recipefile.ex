defmodule RecipeUtil.File do
  def run(%{} = args \\ %{}) do
    source = Map.get(args, :source)
    dest = Map.get(args, :dest)

    with {:ok, file} <- File.open(source),
    data <- IO.binread(file, :eof),
     :ok <- File.close(file) do
      recipe_type = RecipeType.parse(data)
      IO.inspect(recipe_type)
    end
  end
end
