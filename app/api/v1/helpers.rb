module V1
  module Helpers
    def current_user
      username = params[:username] || env['USERNAME']
      password = params[:password] || env['PASSWORD']
      @current_user ||=
        if username.present? && password.present?
          user = User.abled.find_by_username(username)
          user && user.authenticated?(:password, password) ? user : nil
        end
    end

    def paginate(object)
      per_page = (params[:per_page] || 20).to_i
      page = (params[:page] || 1).to_i
      object.page(page).per per_page
    end

    def attributes_for_keys(keys)
      attrs = {}
      keys.each do |key|
        attrs[key] = params[key] if params[key].present?
      end
      attrs
    end

    def forbidden!
      render_error!('403 Forbidden', 403)
    end

    def bad_request!(attribute)
      message = ['400 (Bad request)']
      message << "\"#{attribute.to_s}\" not given"
      render_error!(message.join(' '), 400)
    end

    def not_found!(resource = nil)
      message = ['404']
      message << resource if resource
      message << 'Not Found'
      render_error!(message.join(' '), 404)
    end

    def unauthorized!
      render_error!('401 Unauthorized', 401)
    end

    def not_allowed!
      render_error!('Method Not Allowed', 405)
    end

    def conflict!(message = nil)
      render_error!(message || '409 Conflict', 409)
    end

    def render_error!(message, status)
      error!({message: message}, status)
    end
  end
end