class PaginationListLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer
  include ActionView::Helpers::TagHelper

  protected

  def page_number(page)
    unless page == current_page
      content_tag(:li, link_to(page, page, :rel => rel_value(page)))
    else
      content_tag(:li, page, :class => "current")
    end
  end

  def previous_or_next_page(page, text, classname)
    if page
      content_tag(:li, link_to(text, page), :class => classname)
    else
      content_tag(:li, text, :class => classname + ' disabled')
    end
  end

  def html_container(html)
    content_tag(:ul, html, container_attributes)
  end

end