module ApplicationHelper
  def notify note
    if note.match? /-,|,-/
      note.string_between_markers '-,', ',-'
    else
      note
    end
  end
end
