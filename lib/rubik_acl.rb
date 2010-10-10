module RubikAcl

  mattr_accessor :actions_permissions
  @@actions_permissions = {}

  @@lock = Mutex.new

  mattr_accessor :files_with_permissions_path
  @@files_with_permissions_path = '/config/acl'

  mattr_accessor :reload_permissions_on_each_request
  @@reload_permissions_on_each_request = false

  # This method provides configuration options:
  #
  #   RubikAcl.setup do |config|
  #     config.files_with_permissions_path = 'path/to/files'
  #     config.reload_permissions_on_each_request = true
  #   end
  #
  def self.setup
    yield(self)
  end

  # Initializes ACL by giving logged user group_id and current controller name.
  # Method call may be located in before_filter of application controller.
  def self.init(rubik_acl_group_id, controller)
    Thread.current[:rubik_acl_group_id] = rubik_acl_group_id.to_i
    Thread.current[:rubik_acl_controller_name] = controller.to_s
    Thread.current.key?(:rubik_acl_controller_name) or raise("Controller hasn't been initialized!!!")
    load_action_permissions_for(Thread.current[:rubik_acl_controller_name])
  end

  # Method used for checking permissions. Optional controller name may be
  # specified to check permission for other controller than curently processed.
  def self.permission?(action, controller = nil)
    Thread.current[:rubik_acl_group_id] or raise "User group hasn't been initialized!!!"
    controller ||= Thread.current[:rubik_acl_controller_name]
    if controller.nil?
      @@actions_permissions or raise "Action permissions hasn't been initialized!!!"
      check_permission_for(@@actions_permissions[controller], action.to_s)
    else
      load_action_permissions_for(controller)
      check_permission_for(@@actions_permissions[controller.to_s], action.to_s)
    end
  end

  private

  def self.load_action_permissions_for(controller)
    @@lock.synchronize do
      if @@actions_permissions[controller.to_s].nil? || reload_permissions_on_each_request
        File.open("#{files_with_permissions_path}/#{controller.to_s}.yml", File::RDONLY) do |file|
          @@actions_permissions[controller.to_s] = YAML::load(file)
        end
      end
    end
  end

  def self.check_permission_for(actions_permission, action)
    if actions_permission[action]
      unless actions_permission[action].zero?
        unless Thread.current[:rubik_acl_group_id].zero?
          (actions_permission[action] & Thread.current[:rubik_acl_group_id]) == Thread.current[:rubik_acl_group_id]
        else
          false
        end
      else
        true
      end
    else
      false
    end
  end
  
end
