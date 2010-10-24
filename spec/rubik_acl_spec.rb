require 'spec_helper'
require 'rubik_acl'

describe "Not configured RubikAcl" do
  it "should raise RuntimeError when checking permission without given controller name" do
    lambda {RubikAcl.permission?(:foo)}.should raise_exception(RuntimeError)
  end

  it "should raise RuntimeError when checking permission with given controller name" do
    lambda {RubikAcl.permission?(:foo, :bar)}.should raise_exception(RuntimeError)
  end

end

describe "Configured RubikAcl" do
  before(:each) do
    RubikAcl.setup do |config|
      config.files_with_permissions_path = File.expand_path('../example_files', __FILE__)
      config.reload_permissions_on_each_request = true
      config.groups = %w(admin member guest)
    end
  end

  it "should raise RuntimeError while initialization when not existing user group given" do
    lambda {RubikAcl.init(:not_existion_group, :example_permissions)}.should raise_exception(RuntimeError)
  end

  describe "when guest executes action" do
    before(:each) do
      RubikAcl.init(:guest, :example_permissions)
    end

    describe "when controller parameter specified" do
      it "should allow for access to anyone_allowed_action" do
        RubikAcl.permission?(:anyone_allowed_action, :example_permissions).should be_true
      end
    end

    describe "when controller parameter not specified" do
      it "should allow for access to anyone_allowed_action" do
        RubikAcl.permission?(:anyone_allowed_action).should be_true
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

      it "should deny for access to no_one_allowed_action" do
        RubikAcl.permission?(:no_one_allowed_action).should be_false
      end

      it "should deny for access to not_existing_action" do
        RubikAcl.permission?(:not_existing_action).should be_false
      end
    end
  end

  describe "when admin executes action" do
    before(:each) do
      RubikAcl.init(:admin, :example_permissions)
    end

    it "should allow for access to anyone_allowed_action" do
      RubikAcl.permission?(:anyone_allowed_action).should be_true
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

    it "should deny for access to no_one_allowed_action" do
      RubikAcl.permission?(:no_one_allowed_action).should be_false
    end

    it "should deny for access to not_existing_action" do
      RubikAcl.permission?(:not_existing_action).should be_false
    end
  end

  describe "when member executes action" do
    before(:each) do
      RubikAcl.init(:member, :example_permissions)
    end

    it "should allow for access to anyone_allowed_action" do
      RubikAcl.permission?(:anyone_allowed_action).should be_true
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

    it "should deny for access to no_one_allowed_action" do
      RubikAcl.permission?(:no_one_allowed_action).should be_false
    end
    
    it "should deny for access to not_existing_action" do
      RubikAcl.permission?(:not_existing_action).should be_false
    end
  end

end
