# yamled acl #

Simple authorization library for Ruby on Rails in which permissions are stored in YAML files. Provides porotection before unauthorized access to controller actions. Very simple to configure and use.

## Installation ##

Using gemfile

    gem "yamled_acl"

or using gem command

    gem install "yamled_acl"

or as a plugin

    rails plugin install git://github.com/pkubicki/yamled_acl.git

## Configuration ##

YamledAcl provides following configuration options, you could set them through setup method:

* *files_with_permissions_path* - path to files with permissions, (default: "config/acl")
* *reload_permissions_on_each_request* - as name says, for Rails you may want to set Rails.env.development? (default: false)
* *groups* - allows to specify groups names, it's empty by default
* *guest_group_name* - allows to override default guest group name (default: "guest"), guest group name is added to groups table automatically

For Rails application the best place to store configuration is an initializer.
An example:

    # config/initialzers/yamled_acl.rb:

    YamledAcl.setup do |config|
      config.files_with_permissions_path = 'config/acl'
      config.reload_permissions_on_each_request = Rails.env.development?
      config.groups = %w(admin member)
      config.guest_group_name = 'guest'
    end

In the ApplicationController you should add

    before_filter :authorize

It assumes that there is already defined *current_user* method which returns logged user object. User object should respond to *group_name* method which should return name of current user group. If you want to override method name returning group name it could be done by current_user_group_method of the controller. Here is an example:

    # app/controllers/application_controller.rb

    class ApplicationController < ActionController::Base
      current_user_group_method: group
      before_filter :authorize
    end

## Setting up permissions ##

Permissions are stored in yaml files. Each action of controller should have defined which groups are allowed to access it. It could be done by using one of the following options: allow_all, deny_all, group name or array of group names.
An example:

    # config/acl/posts.yml

    index: allow_all
    show: allow_all
    new: admin
    create: admin
    edit: [admin, member]
    update: [admin, member]
    destroy: deny_all

## Helper methods ##

Following methods may be used in controllers and views:

* *allowed_to?(action_name, controller_name)* - it takes two arguments action_name and controller_name but if the second one is not given currelntly processed controller name will be used

    <% if allowed_to?(:update) %>
      <%= link_to "Edit", edit_post_path(@post) %>
    <% end %>

* *logged_in?* - returns true if there is a logged in user

## Copyright ##

Copyright &copy; 2010 Paweł Kubicki. See LICENSE for details.

