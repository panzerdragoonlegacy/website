module Admin::TableHelper
  def link_to_sort(column, title = nil)
    title ||= column.titleize
    if column == sort_column && sort_direction == 'asc'
      direction = 'desc'
    else
      direction = 'asc'
    end
    arrow = sort_arrow(column, direction)
    link_to(title, sort: column, direction: direction) + ' ' + arrow
  end

  private

  def sort_arrow(column, direction)
    if column == sort_column
      return '▲' if direction == 'asc'
      return '▼' if direction == 'desc'
    end
    return nil
  end
end
