defmodule RecipeType do
  defstruct [
    :header_len,
    :recipe_name,
    :recipe_descr,
    :object_id,
    :partition_num,
    :list_count,
    :list_names_len,
    :list_names,
    :list_list
  ]

  defmodule ListType do
    defstruct [
      :list_size,
      :list_name,
      :field_no,
      :type,
      :display,
      :edit,
      :ask_phil1,
      :ask_phil2,
      :ask_phil3,
      :ask_phil4,
      :ask_phil5,
      :stencil_size,
      :stencil_naplps,
      :original_size,
      :original_naplps
    ]
  end

  def parse(data) do
    <<"GCULIST", 0x00, 0x50020001::32-big, header_len::16-little, rest1::binary>> = data

    IO.puts("header len is #{header_len}")

    <<
      0x01011500::32-big,
      recipe_name::binary-size(21),
      0x02011F00::32-big,
      recipe_descr::binary-size(31),
      0x03011B00::32-big,
      object_id::binary-size(27),
      0x04010300::32-big,
      partition_num::binary-size(3),
      0x05010200::32-big,
      list_count::16-little,
      0x0601::16-big,
      list_names_len::16-little,
      list_names::binary-size(list_names_len),
      rest2::binary
    >> = rest1

    IO.puts("Made it here.")
    list_list = parse_lists(list_count, rest2)

    {:ok,
     %RecipeType {
       header_len: header_len,
       recipe_name: recipe_name,
       recipe_descr: recipe_descr,
       object_id: object_id,
       partition_num: partition_num,
       list_count: list_count,
       list_names_len: list_names_len,
       list_names: String.split(list_names, << 0 >>) |> List.delete_at(-1),
       list_list: list_list
     }, rest2 }

  end

  # defp parse_lists(list_count, data), do: parse_one_list(list_count, [], data)
  defp parse_lists(list_count, data), do: parse_one_list(list_count, [], data)

  defp parse_one_list(0, lists, _data), do: lists

  defp parse_one_list(list_count, lists, data) do
    alias RecipeType.ListType

    IO.puts("List Count is #{list_count}")
    <<
      0x0002::16-big,
      list_size::16-little,
      0x01020b00::32-big,
      list_name::binary-size(11),
      0x02020400::32-big,
      field_no::binary-size(4),
      0x03020600::32-big,
      type::16-little,
      display::16-little,
      edit::16-little,
      0x04020800::32-big,
      ask_phil1::binary-size(8),
      0x05020400::32-big,
      ask_phil2::binary-size(4),
      0x06020400::32-big,
      ask_phil3::binary-size(4),
      0x09021d00::32-big,
      ask_phil4::binary-size(29),
      0x0a021d00::32-big,
      ask_phil5::binary-size(29),
      0x0702::16-big,
      stencil_size::16-little,
      stencil_naplps::binary-size(stencil_size),
      0x0b02::16-big,
      original_size::16-little,
      original_naplps::binary-size(original_size),
      rest::binary
    >> = data

    a_list = %ListType{
      list_size: list_size,
      list_name: list_name,
      field_no: field_no,
      type: type,
      display: display,
      edit: edit,
      ask_phil1: ask_phil1,
      ask_phil2: ask_phil2,
      ask_phil3: ask_phil3,
      ask_phil4: ask_phil4,
      ask_phil5: ask_phil5,
      stencil_size: stencil_size,
      stencil_naplps: stencil_naplps,
      original_size: original_size,
      original_naplps: original_naplps
    }
    parse_one_list(list_count - 1, lists ++ [a_list], rest)
  end

  def generate(_recipe_struct) do
  end
end
