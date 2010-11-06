require 'spec_helper'
require 'yamled_acl'

describe YamledAcl do

  context "when setup not invoked before" do

    describe ".permission?" do

      context "when resource name not given" do

        it "raises UninitializedGroup" do
          expect{YamledAcl.permission?(:foo)}.to raise_error(YamledAcl::UninitializedGroup)
        end

      end # when resource name not given

      context "when resource name given" do

        it "raises UninitializedGroup" do
          expect{YamledAcl.permission?(:foo, :bar)}.to raise_error(YamledAcl::UninitializedGroup)
        end

      end # when resource name given

    end # .permission

  end # when setup not invoked before

  context "when setup invoked before" do
    before(:all) do
      YamledAcl.setup do |config|
        config.files_with_permissions_path = File.expand_path('../example_files', __FILE__)
        config.reload_permissions_on_each_request = true
        config.groups = %w(admin member guest)
      end
    end

    describe ".init" do

      context "when not existing user group given" do

        it "raises NotExistingGroup" do
          expect{YamledAcl.init(:not_existion_group, :example_permissions)}.to raise_error(YamledAcl::NotExistingGroup)
        end

      end # when not existing user group given

      context "when given resource name is a nil" do

        it "raises UninitializedResource" do
          expect{YamledAcl.init(:not_existion_group, nil)}.to raise_error(YamledAcl::UninitializedResource)
        end

      end # when given resource name is a nil

    end # .init

    describe ".permission?" do

      context "when given group is a guest" do

        before do
          YamledAcl.init(:guest, :example_permissions)
        end

        context "when using resource name specified by a second parameter" do

          it "allows for access to anyone_allowed_action" do
            YamledAcl.permission?(:anyone_allowed_action_2, :example_permissions_2).should be_true
          end

        end # when using resource name specified by a second parameter

        context "when using resource name specified with .init method" do

          it "allows for access to anyone_allowed_action" do
            YamledAcl.permission?(:anyone_allowed_action).should be_true
          end

          it "denies for access to admin_allowed_action" do
            YamledAcl.permission?(:admin_allowed_action).should be_false
          end

          it "denies for access to member_allowed_action" do
            YamledAcl.permission?(:member_allowed_action).should be_false
          end

          it "denies for access to admin_and_member_allowed_action" do
            YamledAcl.permission?(:admin_and_member_allowed_action).should be_false
          end

          it "denies for access to not_existing_action" do
            YamledAcl.permission?(:not_existing_action).should be_false
          end

          it "denies for access to no_one_allowed_action" do
            YamledAcl.permission?(:no_one_allowed_action).should be_false
          end

          it "denies for access to not_existing_action" do
            YamledAcl.permission?(:not_existing_action).should be_false
          end

        end # without resource name parameter given

      end # when given group is a guest

      context "when given group is an admin" do

        before do
          YamledAcl.init(:admin, :example_permissions)
        end

        it "allows for access to anyone_allowed_action" do
          YamledAcl.permission?(:anyone_allowed_action).should be_true
        end

        it "allows for access to admin_allowed_action" do
          YamledAcl.permission?(:admin_allowed_action).should be_true
        end

        it "denies for access to member_allowed_action" do
          YamledAcl.permission?(:member_allowed_action).should be_false
        end

        it "allows for access to admin_and_member_allowed_action" do
          YamledAcl.permission?(:admin_and_member_allowed_action).should be_true
        end

        it "denies for access to no_one_allowed_action" do
          YamledAcl.permission?(:no_one_allowed_action).should be_false
        end

        it "denies for access to not_existing_action" do
          YamledAcl.permission?(:not_existing_action).should be_false
        end

      end # when given group is an admin

      context "when given group is a member" do

        before do
          YamledAcl.init(:member, :example_permissions)
        end

        it "allows for access to anyone_allowed_action" do
          YamledAcl.permission?(:anyone_allowed_action).should be_true
        end

        it "denies for access to admin_allowed_action" do
          YamledAcl.permission?(:admin_allowed_action).should be_false
        end

        it "allows for access to member_allowed_action" do
          YamledAcl.permission?(:member_allowed_action).should be_true
        end

        it "allows for access to admin_and_member_allowed_action" do
          YamledAcl.permission?(:admin_and_member_allowed_action).should be_true
        end

        it "denies for access to no_one_allowed_action" do
          YamledAcl.permission?(:no_one_allowed_action).should be_false
        end

        it "denies for access to not_existing_action" do
          YamledAcl.permission?(:not_existing_action).should be_false
        end

      end # when given group is a member

    end # .permission?

  end # when setup invoked before

end # YamledAcl

