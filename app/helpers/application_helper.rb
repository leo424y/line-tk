module ApplicationHelper
  def notify note
    if note.match? /-,|,-/
      note.string_between_markers '-,', ',-'
    else
      note
    end
  end

  def line_link url, note
    "#{url}#:~:text=#{note}"
  end

  def random_colors
    "##{Random.bytes(3).unpack1('H*')}"
  end
end
