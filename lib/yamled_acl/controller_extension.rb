module YamledAcl

  # Module included into controllers.
  #
  # A controller should have defined current_user method. This method should
  # respond to "group_name" method which returns name of group that logged in
  # user belongs to. Optionally name of this method could be changed using
  # current_user_group_method.
  #
  module ControllerExtension

    module ClassMethods

      # Allow to override default name of current_user object method which
      # returns name of user group.
      def current_user_group_method(method_name = nil)
        if method_name
          @current_user_group_method = method_name
        else
          @current_user_group_method or 'group_name'
        end
      end

    end # ClassMethods

    def self.included(base)
      base.extend ClassMethods
      base.helper_method :allowed_to?, :logged_in?
    end

    protected

    # Checks current user permission for specified action. It takes two
    # arguments action_name and controller_name but if the second one is not
    # given currelntly processed controller name will be used.
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
      YamledAcl.permission?(action, controller)
    end

    # This method should be be called by before_filter.
    #
    #   before_filter :authorize
    #
    def authorize
      YamledAcl.init(current_user_group_name, params[:controller])
      allowed_to?(params[:action]) or raise(YamledAcl::AccessDenied)
    end

    # Returns true if there is a logged in user.
    # It assumes that controller have curent_user method defined.
    def logged_in?
      !!current_user
    end

    # Returns current user group name. Used by authorize.
    def current_user_group_name
      logged_in? ? current_user.send(self.class.current_user_group_method) : YamledAcl.guest_group_name
    end

  end # ControllerExtension
end # YamledAcl

if defined?(ActionController)
  ActionController::Base.class_eval do
    include YamledAcl::ControllerExtension
  end
end

