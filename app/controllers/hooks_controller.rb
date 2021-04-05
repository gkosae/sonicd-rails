class HooksController < ApplicationController
  def sentry
    SentryMailer.sentry_event(
      sentry_event: sentry_event,
      mail_list: mail_list
    ).deliver_now

    head :no_content
  end

  def health
    json_response(
      message: 'Healthy'
    )
  end

  private

  def mail_list
    params[:mail_list] || []
  end

  def sentry_event
    SentryEvent.new(request.body.read)
  end
end
