require 'spec_helper'
require 'rubik_acl/exceptions'
require 'rubik_acl/controller_extension'

describe RubikAcl::ControllerExtension, "when controller initialized" do

  before(:each) do
    @controller_class = ActionController::Base
    @controller = @controller_class.new
  end

  it "should respond to authorize" do
    @controller.should respond_to(:authorize)
  end

  it "should respond to current_user_group_name" do
    @controller.should respond_to(:current_user_group_name)
  end

  context "when there is logged in user" do
    before(:each) do
      @controller.stub(:logged_in?).and_return(true)
    end

    context "and user belongs to admin group" do
      before(:each) do
        admin_user = double('current_user')
        admin_user.stub(:group_name).and_return('admin')
        @controller.stub(:current_user).and_return(admin_user)
        RubikAcl.stub(:init)
        RubikAcl.stub(:permission?) do |action_name, controller_name|
          case action_name
          when 'admin_allowed_action'
            true
          when 'admin_not_allowed_action'
            false
          end
        end
      end

      it "current_user_group_name should return admin group name" do
        @controller.send(:current_user_group_name).should == 'admin'
      end

      context "and trying to perform action with granted access" do
        before(:each) do
          @controller.stub(:params).and_return({:action => "admin_allowed_action"})
        end

        it "authorize should return true and not raise any error" do
          expect{@controller.send(:authorize)}.to_not raise_error
          @controller.send(:authorize).should == true
        end

      end

      context "and trying to perform action without granted access" do
        before(:each) do
          @controller.stub(:params) do
            {
              :action => "admin_not_allowed_action",
              :controller => 'any_controller'
            }
          end
        end

        it "authorize should raise RubikAcl::AccessDenied" do
          expect{@controller.send(:authorize)}.to raise_error(RubikAcl::AccessDenied)
        end

      end
    end
  end

  context "when there is no logged in user" do
    before(:each) do
      @controller.stub(:logged_in?).and_return(false)
      RubikAcl.stub(:guest_group_name).and_return('guest')
    end

    it "current_user_group_name should return guest group name" do
      @controller.send(:current_user_group_name).should == RubikAcl.guest_group_name
    end

  end
  
end

