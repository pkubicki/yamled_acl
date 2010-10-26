module RubikAcl

  # Module included into controllers.
  # 
  # The controller should have defined two methods:
  #
  # * logged_in? which returns true or false current_user method which returns
  #   curren_user object
  #
  # * it should respond to group_name method which returns name of
  #   group that logged in user belongs to.
  #
  module ControllerExtension


    # Checks current user permission for specified action. Optionally if
    # checked action belongs to different controller than currently processed
    # it name should be specified as a second parameter.
    #
    # In controllers:
    #
    #   allowed_to?(:destroy)
    #
    #   allowed_to?(:create, :posts)
    #
    # In views:
    #
    #   <% if allowed_to?(:create) %>
    #     <%= link_to "New Post", new_post_path %>
    #   <% end %>
    #
    def allowed_to?(action, controller = nil)
      RubikAcl.permission?(action, controller)
    end
    
    def self.included(base)
      base.helper_method :allowed_to?
    end

    protected

    # This method should be set to be called by before_filter.
    # 
    #   before_filter :authorize
    #
    def authorize
      RubikAcl.init(current_user_group_name, params[:controller])
      allowed_to?(params[:action]) or raise(RubikAcl::AccessDenied)
    end

    def current_user_group_name
      logged_in? ? current_user.group_name : RubikAcl.guest_group_name
    end

  end
end

if defined? ActionController
  ActionController::Base.class_eval do
    include RubikAcl::ControllerExtension
  end
end
