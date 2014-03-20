Before do |scenario|
  DatabaseCleaner.clean
end

After do |scenario|
  Delorean.back_to_the_present
end

Before('@disable-webmock') do
  WebMock.disable!
end

After('@disable-webmock') do
  WebMock.enable!
end
