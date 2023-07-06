defmodule NewsHeadlines do
  def page_setup(buffer, page_number, total_pages) do
    <<
      buf1::binary-size(9),
      _extension1,
      _extension2,
      _orig_page_number,
      buf2::binary-size(3),
      _orig_stage_flags,
      _orig_total_pages,
      rest::binary
    >> = buffer

    <<
      buf1::binary-size(9),
      0x20,
      0x20,
      page_number,
      buf2::binary-size(3),
      0x20,
      total_pages,
      rest::binary
    >>
  end
end
