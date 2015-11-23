class ApplicationMailer < ActionMailer::Base
  default from: "admin@test.com"
  layout 'mailer'
end
