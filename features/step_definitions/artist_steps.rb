Given /^I have an artist named (.+)$/ do |name|
  Artist.create!(:name => name)
end
