#@see app/helpers/sessions_helper
module SessionsHelper
  # cookies.signed在test env 找不到
  def test_signed_in?
    !session[:username].nil?
  end
end