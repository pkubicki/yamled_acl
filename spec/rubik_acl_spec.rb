require 'spec_helper'
require 'rubik_acl'

describe "Uninitialized" do
  it "should raise RuntimeError when checking permission without given controller name" do
    lambda { RubikAcl.permission?(:foo) }.should raise_exception(RuntimeError)
  end

  it "should raise RuntimeError when checking permission with given controller name" do
    lambda { RubikAcl.permission?(:foo, :bar) }.should raise_exception(RuntimeError)
  end
end

describe "Initialized" do
  before(:each) do
    RubikAcl.setup do |config|
      config.files_with_permissions_path = File.expand_path('../example_files', __FILE__)
      config.reload_permissions_on_each_request = true
    end
  end

  describe "when guest (user with group_id = 0) executes action" do
    before(:each) do
      RubikAcl.init(0, :example_permissions)
    end

    it "should allow for access to guest_allowed_action" do
      RubikAcl.permission?(:guest_allowed_action).should be_true
    end

    it "should deny for access to admin_allowed_action" do
      RubikAcl.permission?(:admin_allowed_action).should be_false
    end

    it "should deny for access to member_allowed_action" do
      RubikAcl.permission?(:member_allowed_action).should be_false
    end

    it "should deny for access to admin_and_member_allowed_action" do
      RubikAcl.permission?(:admin_and_member_allowed_action).should be_false
    end

    it "should deny for access to not_existing_action" do
      RubikAcl.permission?(:not_existing_action).should be_false
    end
  end

  describe "when admin (user with group_id = 1) executes action" do
    before(:each) do
      RubikAcl.init(1, :example_permissions)
    end

    it "should allow for access to guest_allowed_action" do
      RubikAcl.permission?(:guest_allowed_action).should be_true
    end

    it "should allow for access to admin_allowed_action" do
      RubikAcl.permission?(:admin_allowed_action).should be_true
    end

    it "should deny for access to member_allowed_action" do
      RubikAcl.permission?(:member_allowed_action).should be_false
    end

    it "should allow for access to admin_and_member_allowed_action" do
      RubikAcl.permission?(:admin_and_member_allowed_action).should be_true
    end

    it "should deny for access to not_existing_action" do
      RubikAcl.permission?(:not_existing_action).should be_false
    end
  end

  describe "when member (user with group_id = 2) executes action" do
    before(:each) do
      RubikAcl.init(2, :example_permissions)
    end

    it "should allow for access to guest_allowed_action" do
      RubikAcl.permission?(:guest_allowed_action).should be_true
    end

    it "should deny for access to admin_allowed_action" do
      RubikAcl.permission?(:admin_allowed_action).should be_false
    end

    it "should allow for access to member_allowed_action" do
      RubikAcl.permission?(:member_allowed_action).should be_true
    end

    it "should allow for access to admin_and_member_allowed_action" do
      RubikAcl.permission?(:admin_and_member_allowed_action).should be_true
    end

    it "should deny for access to not_existing_action" do
      RubikAcl.permission?(:not_existing_action).should be_false
    end
  end

end
