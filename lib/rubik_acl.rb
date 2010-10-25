require 'rubik_acl/exceptions'

module RubikAcl

  ALLOW_ALL = 'allow_all'
  DENY_ALL = 'deny_all'

  @@lock = Mutex.new

  mattr_accessor :actions_permissions
  @@actions_permissions = {}

  mattr_accessor :files_with_permissions_path
  @@files_with_permissions_path = '/config/acl'

  mattr_accessor :reload_permissions_on_each_request
  @@reload_permissions_on_each_request = false
  
  mattr_accessor :groups
  @@groups = []

  # This method provides configuration options:
  #
  #   RubikAcl.setup do |config|
  #     config.files_with_permissions_path = 'path/to/files'
  #     config.reload_permissions_on_each_request = true
  #     config.groups = %w(admin member)
  #   end
  #
  def self.setup
    yield(self)
  end

  # Initializes ACL by giving logged user group name and currently processed
  # resource name.
  def self.init(group_name, resource_name)
    init_resource(resource_name)
    init_group(group_name)
    load_action_permissions_for(Thread.current[:rubik_acl_resource_name])
  end

  # Method used for checking permissions. Optional resource name may be
  # specified to check permission for other resource than curently processed.
  def self.permission?(action, resource = nil)
    Thread.current.key?(:rubik_acl_group) or raise(UninitializedGroup)
    if resource.nil?
      check_permission_for(@@actions_permissions[Thread.current[:rubik_acl_resource_name]][action.to_s])
    else
      load_action_permissions_for(resource)
      check_permission_for(@@actions_permissions[resource.to_s][action.to_s])
    end
  end

  private

  def self.load_action_permissions_for(resource)
    @@lock.synchronize do
      if @@actions_permissions[resource.to_s].nil? || reload_permissions_on_each_request
        File.open("#{files_with_permissions_path}/#{resource.to_s}.yml", File::RDONLY) do |file|
          @@actions_permissions[resource.to_s] = YAML::load(file)
        end
      end
    end
  end

  def self.check_permission_for(allowed)
    return false unless allowed
    return false if allowed == DENY_ALL
    return true if allowed == ALLOW_ALL
    allowed.include?(Thread.current[:rubik_acl_group])
  end

  def self.init_resource(resource_name)
    !resource_name.blank? or raise(UninitializedResource)
    Thread.current[:rubik_acl_resource_name] = resource_name.to_s
  end

  def self.init_group(group_name)
    !group_name.blank? or raise(UninitializedGroup)
    @@groups.include?(group_name.to_s) or raise(NotExistingGroup)
    Thread.current[:rubik_acl_group] = group_name.to_s
  end

end
