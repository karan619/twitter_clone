class ApplicationMailer < ActionMailer::Base
  default from: "noreply@twitter.com"
  layout 'mailer'
end
