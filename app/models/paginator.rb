class Paginator
  def initialize(page, pages_count, max_size = 5)
    @page = page.to_i
    @page = 1 if @page == 0
    @pages_count = pages_count.to_i
    @max_size = max_size
  end

  def to_html
    return if @pages_count == 1

    html_text = <<EOL
<nav class='pagination-center'>
  <ul class='pagination'>
    #{li_html}
  </ul>
</nav>
EOL
    html_text.html_safe
  end

  private

  def li_html
    [prev_page, *numbered_pages, next_page].join.html_safe
  end

  def prev_page
    <<EOL
<li class='#{'disabled' if first_page?}'>
  <a href='?page=#{@page - 1}' aria-label='Previous'>
    <span aria-hidden='true'>&laquo;</span>
  </a>
</li>
EOL
  end

  def numbered_pages
    page_numbers.map do |page|
      page_link(page)
    end
  end

  def page_numbers
    return (1..@pages_count) unless @pages_count > @max_size
    return (1..@max_size) if low_limit == 1
    return (@pages_count - @max_size..@pages_count) if high_limit == @pages_count

    (low_limit..high_limit)
  end

  def high_limit
    [@page + @max_size / 2, @pages_count].min
  end

  def low_limit
    [@page - @max_size / 2, 1].max
  end

  def next_page
    <<EOL
<li class='#{'disabled' if last_page?}'>
  <a href='?page=#{@page + 1}' aria-label="Next">
    <span aria-hidden="true">&raquo;</span>
  </a>
</li>
EOL
  end

  def page_link(page)
    <<EOL
<li class='#{'active' if current_page?(page)}'>
  <a href='?page=#{page}' aria-label='Page #{page}'>
    <span aria-hidden='true'>#{page}</span>
  </a>
</li>
EOL
  end

  def current_page?(page)
    page == @page
  end

  def first_page?
    @page == 1
  end

  def last_page?
    @page == @pages_count
  end
end
