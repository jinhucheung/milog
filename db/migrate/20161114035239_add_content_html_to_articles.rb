class AddContentHtmlToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :content_html, :text
  end
end
