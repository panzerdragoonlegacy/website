module ChaptersHelper
  def previous_chapter(chapter)
    numbers = sequence_numbers_in_order(chapter)
    return false if numbers.index(chapter.sequence_number) == 0
    prev_number = numbers[numbers.index(chapter.sequence_number) - 1]
    return(
      Page.where(
        parent_page_id: chapter.parent_page.id,
        sequence_number: prev_number
      ).first
    )
  end

  def next_chapter(chapter)
    numbers = sequence_numbers_in_order(chapter)
    return false if numbers.index(chapter.sequence_number) == numbers.length - 1
    next_number = numbers[numbers.index(chapter.sequence_number) + 1]
    Page.where(
      parent_page_id: chapter.parent_page.id,
      sequence_number: next_number
    ).first
  end

  def sequence_numbers_in_order(chapter)
    chapter.parent_page.chapters.map { |chapter| chapter.sequence_number }
  end
end
