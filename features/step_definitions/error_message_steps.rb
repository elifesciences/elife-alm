### GIVEN ###
Given /^we have (\d+) error messages?$/ do |number|
  FactoryGirl.create_list(:error_message, number.to_i)
end

Given /^we have (\d+) resolved error messages?$/ do |number|
  FactoryGirl.create_list(:error_message, number.to_i, :unresolved => false)
end

### WHEN ###
When /^I click on the "(.*?)" button$/ do |button_name|
  click_button button_name
  page.driver.render("tmp/capybara/#{button_name}.png")
end

When /^I click on the "(.*?)" link$/ do |link_name|
  click_link link_name
end

When /^I go to page (\d+)$/ do |page_number|
  within(".pagination") do
    click_link page_number
  end
end

When /^I click on the "(.*?)" menu item of the Delete button of the first error message and confirm$/ do |menu_item|
  scope = menu_item.split.last.downcase
  id = first('.accordion-toggle')[:id][5..-1]
  click_link "link_#{id}"
  within("#error_message_#{id}") do
    click_link "#{id}-delete"
    click_link "#{id}-delete-#{scope}"
  end
end

### THEN ###
Then /^I should see (\d+) error messages?$/ do |number|
sleep 5
    page.driver.render("tmp/capybara/#{number}_error_messages.png")
  page.has_css?('.accordion-group', :visible => true, :count => number.to_i).should be_true
end

Then /^I should see the "(.*?)" error number$/ do |error_number|
  within(".accordion-heading") do
    page.should have_content error_number
  end
end

Then /^I should see the "(.*?)" error message$/ do |error_message|
  page.should have_content error_message
end

Then /^I should see the "(.*?)" error$/ do |error|
  within(".accordion-heading") do
    page.should have_content error
  end
end

Then /^I should see the "(.*?)" class name$/ do |class_name|
  within(".accordion-body") do
    page.has_css?('p.class_name', :text => class_name, :visible => true).should be_true
  end
end

Then /^I should not see the "(.*?)" class name$/ do |class_name|
  within(".accordion-body") do
    page.has_css?('p.class_name', :text => class_name, :visible => true).should_not be_true
  end
end

Then /^I should see the "(.*?)" status$/ do |status|
  within(".accordion-body") do
    page.has_css?('div.collapse', :text => status, :visible => true).should be_true
  end
end
