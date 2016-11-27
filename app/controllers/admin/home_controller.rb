class Admin::HomeController < ApplicationController
  before_action :check_signed_in
  before_action :check_activated
  before_action :check_admin

  layout 'admin'

  def index
    @user = current_user
    @summary = {
      user:      { total: User.all.size,     normal: User.normal.size, 
                   admin: User.admin.size,   disabled: User.disabled.size  },
      article:   { total: Article.all.size,  posted: Article.posted.size, 
                   unposted: Article.unposted.size },
      category:  { total: Category.all.size, used: Category.used.size,
                   unused: Category.unused.size },
      tag:       { total: Tag.all.size,      used: Tag.used.size,
                   unused: Tag.unused.size },
      comment:   { total: Comment.all.size,  posted: Comment.posted.size,
                   deleting: Comment.deleting.size },
      picture:   { total: Picture.all.size,  posted: Picture.posted.size,
                   unposted: Picture.unposted.size }
    }
  end

end
