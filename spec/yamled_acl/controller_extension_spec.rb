require 'spec_helper'
require 'yamled_acl/exceptions'
require 'yamled_acl/controller_extension'

describe YamledAcl::ControllerExtension do

  describe "instantinated controller" do

    before(:all) do
      @controller_class = Class.new(ActionController::Base)
      @controller_class.current_user_group_method(:group)
      @controller = @controller_class.new
    end

    it "responds to #authorize" do
      @controller.respond_to?(:authorize, true).should be_true 
    end

    it "responds to #logged_in?" do
      @controller.respond_to?(:logged_in?, true).should be_true
    end

    it "responds to #current_user_group_name" do
      @controller.respond_to?(:current_user_group_name, true).should be_true
    end

    context "given logged in user with admin group" do

      before(:each) do
        admin_user = mock(:group => 'admin')
        @controller.stub(:current_user).and_return(admin_user)
        YamledAcl.stub(:init)
        YamledAcl.stub(:permission?) do |action_name, controller_name|
          case action_name
          when 'admin_allowed_action'
            true
          when 'admin_not_allowed_action'
            false
          end
        end
      end

      describe "#current_user_group_name" do

        it "returns 'admin'" do
          @controller.send(:current_user_group_name).should == 'admin'
        end

      end # #current_user_group_name

      context "when trying to perform action with granted access" do

        before(:each) do
          @controller.stub(:params).and_return({:action => "admin_allowed_action"})
        end

        describe "#authorize" do

          it "doesn't raise any error" do
            expect{@controller.send(:authorize)}.to_not raise_error
          end

          it "returns true" do
            @controller.send(:authorize).should == true
          end

        end # #authorize

      end # when trying to perform action with granted access

      context "when trying to perform action without granted access" do

        before(:each) do
          @controller.stub(:params) do
            {
              :action => "admin_not_allowed_action",
              :controller => 'any_controller'
            }
          end
        end

        describe "#authorize" do

          it "raises YamledAcl::AccessDenied" do
            expect{@controller.send(:authorize)}.to raise_error(YamledAcl::AccessDenied)
          end

        end # #authorize

      end # when trying to perform action without granted access

    end # when there is logged in user with admin group

    context "given no logged in user" do

      before(:each) do
        @controller.stub(:current_user).and_return(nil)
        YamledAcl.stub(:guest_group_name).and_return('guest')
      end

      describe "current_user_group_name" do

        it "returns 'guest'" do
          @controller.send(:current_user_group_name).should == YamledAcl.guest_group_name
        end

      end # current_user_group_name

    end # given no logged in user

  end # whem controller instantinated

end # YamledAcl::ControllerExtension

