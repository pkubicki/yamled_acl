require 'yamled_acl/exceptions'
require 'yamled_acl/controller_extension'

module YamledAcl

  ALLOW_ALL = 'allow_all'
  DENY_ALL = 'deny_all'

  @lock = Mutex.new

  class << self
    attr_accessor :actions_permissions
    attr_accessor :files_with_permissions_path
    attr_accessor :reload_permissions_on_each_request
    attr_accessor :groups
    attr_accessor :guest_group_name
  end

  @actions_permissions = {}
  @files_with_permissions_path = 'config/acl'
  @reload_permissions_on_each_request = false
  @groups = []
  @guest_group_name = 'guest'

  # Provides configuration options:
  #
  #   YamledAcl.setup do |config|
  #     config.files_with_permissions_path = 'other/than/default/path'
  #     config.reload_permissions_on_each_request = Rails.env.development?
  #     config.groups = %w(admin member)
  #     config.guest_group_name = 'visitor'
  #   end
  #
  def self.setup
    yield(self)
    @groups << @guest_group_name
  end

  # Initializes ACL by giving logged user group name and currently processed
  # resource name.
  def self.init(group_name, resource_name)
    init_resource(resource_name)
    init_group(group_name)
    load_action_permissions_for(Thread.current[:yamled_acl_resource_name])
  end

  # Method used for checking permissions. Optional resource name may be
  # specified to check permission for other resource than curently processed.
  def self.permission?(action, resource = nil)
    Thread.current.key?(:yamled_acl_group) or raise(UninitializedGroup)
    if resource.nil?
      check(@actions_permissions[Thread.current[:yamled_acl_resource_name]][action.to_s])
    else
      load_action_permissions_for(resource)
      check(@actions_permissions[resource.to_s][action.to_s])
    end
  end

  private

  def self.load_action_permissions_for(resource)
    @lock.synchronize do
      if @actions_permissions[resource.to_s].nil? || reload_permissions_on_each_request
        File.open("#{files_with_permissions_path}/#{resource.to_s}.yml", File::RDONLY) do |file|
          @actions_permissions[resource.to_s] = YAML::load(file)
        end
      end
    end
  end

  def self.check(permission)
    return false unless permission
    return false if permission == DENY_ALL
    return true if permission == ALLOW_ALL
    permission.include?(Thread.current[:yamled_acl_group])
  end

  def self.init_resource(resource_name)
    resource_name or raise(UninitializedResource)
    Thread.current[:yamled_acl_resource_name] = resource_name.to_s
  end

  def self.init_group(group_name)
    group_name or raise(UninitializedGroup)
    @groups.include?(group_name.to_s) or raise(NotExistingGroup)
    Thread.current[:yamled_acl_group] = group_name.to_s
  end

end

