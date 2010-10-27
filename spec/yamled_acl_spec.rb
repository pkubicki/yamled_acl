require 'spec_helper'
require 'yamled_acl'

describe YamledAcl, "when not configured" do
  it "should raise UninitializedGroup when checking permission without given resource name" do
    expect{YamledAcl.permission?(:foo)}.to raise_error(YamledAcl::UninitializedGroup)
  end

  it "should raise UninitializedGroup when checking permission with given resource name" do
    expect{YamledAcl.permission?(:foo, :bar)}.to raise_error(YamledAcl::UninitializedGroup)
  end

end

describe YamledAcl, "when properly configured" do
  before(:each) do
    YamledAcl.setup do |config|
      config.files_with_permissions_path = File.expand_path('../example_files', __FILE__)
      config.reload_permissions_on_each_request = true
      config.groups = %w(admin member guest)
    end
  end

  context "when not existing user group given" do
    it "should raise NotExistingGroup while initialization" do
      expect{YamledAcl.init(:not_existion_group, :example_permissions)}.to raise_error(YamledAcl::NotExistingGroup)
    end
  end

  context "when blank resource name given" do
    it "should raise UninitializedResource while initialization" do
      expect{YamledAcl.init(:not_existion_group, nil)}.to raise_error(YamledAcl::UninitializedResource)
    end
  end

  context "when guest executes action" do
    before(:each) do
      YamledAcl.init(:guest, :example_permissions)
    end

    context "when resource name parameter specified" do
      it "should allow for access to anyone_allowed_action" do
        YamledAcl.permission?(:anyone_allowed_action_2, :example_permissions_2).should be_true
      end
    end

    context "when resource name parameter not specified" do
      it "should allow for access to anyone_allowed_action" do
        YamledAcl.permission?(:anyone_allowed_action).should be_true
      end

      it "should deny for access to admin_allowed_action" do
        YamledAcl.permission?(:admin_allowed_action).should be_false
      end

      it "should deny for access to member_allowed_action" do
        YamledAcl.permission?(:member_allowed_action).should be_false
      end

      it "should deny for access to admin_and_member_allowed_action" do
        YamledAcl.permission?(:admin_and_member_allowed_action).should be_false
      end

      it "should deny for access to not_existing_action" do
        YamledAcl.permission?(:not_existing_action).should be_false
      end

      it "should deny for access to no_one_allowed_action" do
        YamledAcl.permission?(:no_one_allowed_action).should be_false
      end

      it "should deny for access to not_existing_action" do
        YamledAcl.permission?(:not_existing_action).should be_false
      end
    end
  end

  context "when admin executes action" do
    before(:each) do
      YamledAcl.init(:admin, :example_permissions)
    end

    it "should allow for access to anyone_allowed_action" do
      YamledAcl.permission?(:anyone_allowed_action).should be_true
    end

    it "should allow for access to admin_allowed_action" do
      YamledAcl.permission?(:admin_allowed_action).should be_true
    end

    it "should deny for access to member_allowed_action" do
      YamledAcl.permission?(:member_allowed_action).should be_false
    end

    it "should allow for access to admin_and_member_allowed_action" do
      YamledAcl.permission?(:admin_and_member_allowed_action).should be_true
    end

    it "should deny for access to no_one_allowed_action" do
      YamledAcl.permission?(:no_one_allowed_action).should be_false
    end

    it "should deny for access to not_existing_action" do
      YamledAcl.permission?(:not_existing_action).should be_false
    end
  end

  context "when member executes action" do
    before(:each) do
      YamledAcl.init(:member, :example_permissions)
    end

    it "should allow for access to anyone_allowed_action" do
      YamledAcl.permission?(:anyone_allowed_action).should be_true
    end

    it "should deny for access to admin_allowed_action" do
      YamledAcl.permission?(:admin_allowed_action).should be_false
    end

    it "should allow for access to member_allowed_action" do
      YamledAcl.permission?(:member_allowed_action).should be_true
    end

    it "should allow for access to admin_and_member_allowed_action" do
      YamledAcl.permission?(:admin_and_member_allowed_action).should be_true
    end

    it "should deny for access to no_one_allowed_action" do
      YamledAcl.permission?(:no_one_allowed_action).should be_false
    end
    
    it "should deny for access to not_existing_action" do
      YamledAcl.permission?(:not_existing_action).should be_false
    end
  end

end
