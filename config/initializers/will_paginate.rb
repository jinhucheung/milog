require 'will_paginate/view_helpers/action_view'
module WillPaginate
  module ActionView

    class BlogLinkRenderer < LinkRenderer
      protected
      def html_container(html)
        tag :nav, html, class: "pagination"
      end

      def page_number(page)
        if page == current_page
          tag :span, page,  class: 'page-number current'
        else
          link page, page, rel: rel_value(page), class: 'page-number'
        end
      end

      def gap
        tag :span, '&hellip;'.html_safe, class: 'space'
      end

      def previous_or_next_page(page, text, classname)
        if page
          link text, page, class: ('page-number' if @options[:page_links])
        end
      end
    end
  end
end
