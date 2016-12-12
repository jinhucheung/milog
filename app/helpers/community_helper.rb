module CommunityHelper

  def tags_tag(tags)
    return if tags.blank?
    content = tags.map { |tag| link_to '#'+tag.name, community_tag_path(tag.id) }.join ' · '
    sanitize content
  end

end