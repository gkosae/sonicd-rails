class SentryMailer < ApplicationMailer
  def sentry_event(sentry_event:, mail_list: [])
    @event = sentry_event
    mail_list = ['gkosae@gmail.com'] + mail_list

    mail(
      to: mail_list.uniq.join(','),
      subject: "SENTRY: #{sentry_event.project.upcase}"
    )
  end
end