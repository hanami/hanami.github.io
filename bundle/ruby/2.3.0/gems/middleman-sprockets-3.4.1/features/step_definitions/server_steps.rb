Then /^I should get a response with status "(.*?)"$/ do |status|
  (@last_response || @browser.last_response).status.should == status.to_i
end

Given /^wait a second$/ do
  sleep(1)
end
