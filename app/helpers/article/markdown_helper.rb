module Article::MarkdownHelper

  def markdown_parser
    parser = MarkdownIt::Parser.new :commonmark, { linkify: true }
    parser.enable 'table'
    parser.renderer.rules['table_open'] = lambda { |tokens, idx, options, env, renderer| return '<table class="table table-striped table-bordered">'  }
    parser
  end

end
