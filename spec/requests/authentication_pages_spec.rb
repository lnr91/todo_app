require 'spec_helper'

describe 'AuthenticationPages' do

  subject { page }

  describe 'home signin page' do
    before { visit root_path }
    it { should have_selector('form#signin_form_header') }
    it { should have_selector('input#session_email') }
    it { should have_selector('input#session_password') }
    it { should_not have_link('Sign out') }
  end

  describe 'signin' do
    before { visit root_path }
    describe 'with invalid information' do
      before { click_button 'Sign in' }
      it { should have_selector('div.alert.alert-error', text: 'Invalid email/password') }
      it { should have_selector('form#signin_form') }
      describe 'after visiting another page' do
        before { visit signin_path }
        it { should_not have_selector('div.alert.alert-error', text: 'Invalid email/password') }
      end
    end

    describe 'with valid information' do
      let(:user) { Factory(:user) }
      before { log_in user }
      it { should have_selector('div#user_nick_name') }
      it { should have_link('Sign out') }
      describe 'followed by signout' do
        before { click_link 'Sign out' }
        it { should have_selector('form#signin_form_header') }
      end
    end
  end

  describe 'Authorisation' do
    describe 'for non signed in users' do
      let(:user) { Factory(:user) }
      describe 'in Lists Controller' do
        describe 'lists show page' do
          let(:list) { Factory(:list) }
          before { visit user_list_path(user, list) }
          it { should have_selector('form#signin_form') }
        end
        describe 'list create action' do
          before { post user_lists_path(user) }
          specify { response.should redirect_to signin_path }
        end
        describe 'list delete option' do
          let(:list) { Factory(:list, user: user) }
          before { delete user_list_path(user, list) }
          specify { response.should redirect_to signin_path }
        end
      end

      describe 'in Tasks controller' do
        let(:list) { Factory(:list, user: user) }
        describe 'tasks create' do
          before { post user_list_tasks_path(user, list) }
          specify { response.should redirect_to signin_path }
        end
        describe 'tasks update' do
          let(:task) { Factory(:task, list: list) }
          before { put user_list_task_path(user, list, task) }
          specify { response.should redirect_to signin_path }
        end
        describe 'tasks delete' do
          let(:task) { Factory(:task, list: list) }
          before { delete user_list_task_path(user, list, task) }
          specify { response.should redirect_to signin_path }
        end
      end
    end

    describe 'for wrong users' do
      let(:user) { Factory(:user) }
      let(:wrong_user) { Factory(:user) }
      before { log_in user }
      describe 'Lists Controller' do
        describe 'lists show page' do
          let(:list) { Factory(:list, user: wrong_user) }
          before { get user_list_path(wrong_user, list) }
          specify { response.should redirect_to root_path }
        end
        describe 'lists show page with some trick' do
          let(:list) { Factory(:list, user: wrong_user) }
          before { get user_list_path(user, list) }
          specify { response.should redirect_to root_path }
        end

        describe 'going to lists create action' do
          before { post user_lists_path(wrong_user) }
          specify { response.should redirect_to root_path }
        end
        describe 'list delete option' do
          let(:list) { Factory(:list, user: wrong_user) }
          before { delete user_list_path(wrong_user, list) }
          specify { response.should redirect_to root_path }
        end
      end

      describe 'Tasks Controller' do
        let(:list) { Factory(:list, user: wrong_user) }
        describe 'going to tasks create action' do
          before { post user_list_tasks_path(wrong_user, list) }
          specify { response.should redirect_to root_path }
        end
        describe 'task delete option' do
          let(:task) { Factory(:task, list: list) }
          before { delete user_list_task_path(wrong_user, list, task) }
          specify { response.should redirect_to root_path }
        end
        describe 'task delete option with some trick' do
          let(:task) { Factory(:task, list: list) }
          before { delete user_list_task_path(user, list, task) }
          specify { response.should redirect_to root_path }
        end
        describe 'task edit option' do
          let(:task) { Factory(:task, list: list) }
          before { put user_list_task_path(wrong_user, list, task) }
          specify { response.should redirect_to root_path }
        end
        describe 'task edit option with some trick' do
          let(:task) { Factory(:task, list: list) }
          before { put user_list_task_path(user, list, task) }
          specify { response.should redirect_to root_path }
        end
      end

    end
  end

end