class SentryMailer < ApplicationMailer
  def sentry_event(sentry_event)
    @event = sentry_event

    mail(
      to: 'gkosae@gmail.com',
      subject: "SENTRY: #{sentry_event.project.upcase}"
    )
  end
end
