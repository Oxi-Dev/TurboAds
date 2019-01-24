require 'rails_helper'

RSpec.describe NavigationHelper, :type => :helper do
  
    context '#nav_header_content_partials' do
      it "returns messenger_header partial's path" do
        controller.params[:controller] = 'messengers'
        partials = ['layouts/navigation/header/messenger_header']
        expect(helper.nav_header_content_partials).to eq partials
      end
    
      it "returns partials' paths for buttons without dropdowns" do
        controller.params[:controller] = 'not_messengers'
        view.stub(:user_signed_in?).and_return(false)
        partials = ['layouts/navigation/header/toggle_button']
        partials << 'layouts/navigation/header/home_button'
        expect(helper.nav_header_content_partials).to eq partials
      end
    
      it "returns partials' paths for buttons and dropdowns" do
        controller.params[:controller] = 'not_messengers'
        view.stub("user_signed_in?").and_return(true)
        partials = ['layouts/navigation/header/toggle_button']
        partials << 'layouts/navigation/header/home_button'
        partials << 'layouts/navigation/header/dropdowns'
        expect(helper.nav_header_content_partials).to eq partials
      end
    end  
  
    context '#conversation_header_partial_path' do
      it "returns a partial's path for a private conversation's header" do
        conversation = create(:private_conversation)
        expect(helper.conversation_header_partial_path(conversation)). to eq(
          'layouts/navigation/header/dropdowns/conversations/private'
        )
      end
    
      it "returns a partial's path for a group conversation's header" do
        conversation = create(:group_conversation)
        expect(helper.conversation_header_partial_path(conversation)). to eq(
          'layouts/navigation/header/dropdowns/conversations/group'
        )
      end
    end
  
end