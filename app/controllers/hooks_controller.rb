class HooksController < ApplicationController
  def sentry
    SentryMailer.
      sentry_event(SentryEvent.new(request.body.read)).
      deliver_now
    head :no_content
  end
end
