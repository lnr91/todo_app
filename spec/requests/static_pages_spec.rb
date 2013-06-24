require 'spec_helper'

describe 'StaticPages' do

  subject { page }
  describe 'Home page' do

    describe 'When not signed in' do
      before { visit root_path }
      it { should have_selector('title', text: 'Todoodle - Welcome') }
      it { should have_selector('a', text: 'Sign up now !') } # same as below
      it { should have_link('Sign up now !') }
      it { should have_selector('form#signin_form_header') }
      it { should have_selector("input[placeholder='email']") }
      it { should have_selector("input[placeholder='password']") }
      it 'should have right links to other pages on layout' do
        click_link 'Sign up now !'
        page.should have_selector('title', text: 'Todoodle - Sign up')
        visit root_path
        click_link 'Todoodle'
        page.should have_selector('title', text: 'Todoodle - Welcome')
      end
    end

    describe 'When signed in' do
      let(:user) { Factory(:user) }
      before { log_in user }

      describe 'When no lists are present' do
        it 'should show message asking to create list' do
          page.should have_selector('div', text: 'You have no lists ! Create a list now !')
        end
      end

      describe 'when lists are present' do
        before do
          5.times { Factory(:list, user: user) }
          visit root_path
        end
        it 'should show lists on page',js: true do
          user.lists.each do |list|
            page.should have_content(list.name)
          end
          sleep(3)
          #page.should have_no_css('div', text: 'You have no lists ! Create a list now !') #This doesn't work ..I dunno why
          page.should have_selector('div', text: 'You have no lists ! Create a list now !', visible: false)

        end
        it 'should go to tasks page on clicking a list', js: true do
          click_link user.lists.first.name
          page.should have_content(user.lists.first.description)
          page.should have_selector('title', text: 'Todoodle - '+user.lists.first.name)
          page.should have_selector('h2.main_header', text: user.lists.first.name)
        end
      end
    end

    describe 'user interaction with list' do
      let(:user) { Factory(:user) }
      before(:each) do
        log_in user
        fill_in 'Name', with: 'mylist'
        fill_in 'Description', with: 'mylist_description'
        click_button 'Create List'
      end
      Capybara.default_wait_time = 5
      it 'should show new list name using ajax', js: true do
        page.should have_content('mylist')
      end
      it 'should remove list on clicking remove', js: true do
        page.should have_content('mylist')
        click_link 'remove'
        page.should have_no_content('mylist')  #same as page.should_not have_content('mylist') ....but in AJAX requests , should_not must not be used , because it doesn't wait for element to be found ....in case the element is not already on the page
      end
    end

    describe 'List page..i.e tasks' do
      let(:user) { Factory(:user) }

      before do
        @list = Factory(:list, user: user)
        log_in user
        click_link @list.name
      end
      it 'should show the empty message when no task is present' do
        page.should have_selector('div', id: 'tasks_empty', text: 'My little grasshopper..You have no tasks left to do !') # or can also write have_selector('div#tasks_empty',text:'My little ......')
      end

      it 'should show tasks list when tasks are present' do
        task =Factory(:task, list: @list)
        visit user_list_path(user, @list)
        page.should have_selector('label', text: task.description)
      end

      describe 'User interaction with tasks', js: true do

        before do
          fill_in 'Description', with: 'Task 1'
          click_button 'Create Task'
        end
        it 'should add and show task if u fill in form and add', js: true do
          page.should have_selector('label', text: 'Task 1')
        end
        it 'should remove incomplete task on clicking remove button', js: true do
          page.find('div#incomplete_tasks > form').click_link('remove')
          page.should_not have_selector('label', text: 'Task 1')
        end
        it 'should mark tasks  as complete', js: true do
          page.find('div#incomplete_tasks > form > label').click #The child combinator (E > F) can be thought of as a more specific form of the descendant combinator (E F) in that it selects only first-level descendants.
          page.should have_selector('div#completed_tasks > form > label', text: 'Task 1')
          page.should_not have_selector('div#incomplete_tasks > form > label', text: 'Task 1')
        end
        describe 'completed tasks' do
          before do
            page.find('div#incomplete_tasks > form > label').click
          end
          it 'should remove completed task on clicking remove button', js: true do
            page.find('div#completed_tasks > form').click_link('remove')
            page.should_not have_selector('div#completed_tasks > form > label', text: 'Task 1')
          end
          it 'should re-mark tasks  as incomplete when complete task is clicked', js: true do
            page.find('div#completed_tasks > form > label').click
            page.should have_selector('div#incomplete_tasks > form > label', text: 'Task 1')
            page.should_not have_selector('div#completed_tasks > form > label', text: 'Task 1')
          end
        end
      end
    end

  end

end




