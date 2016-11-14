module Article::MarkdownHelper

  def markdown_parser
    parser = MarkdownIt::Parser.new :commonmark, { 
      linkify: true
    }
    parser.enable 'table'
    parser
  end

end
