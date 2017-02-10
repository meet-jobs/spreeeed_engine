module SpreeeedEngine
  module CurrentAuthResourceHelper

    def current_auth_user
      send("current_#{SpreeeedEngine.devise_auth_resource}")
    end

    def current_user_name
      return '' unless current_auth_user
      current_auth_user.respond_to?(:name) ? current_auth_user.name : current_auth_user.email
    end

    def current_user_is_root?
      current_auth_user.respond_to?('is_root?'.to_sym) ? current_auth_user.is_root? : true
    end

  end
end
