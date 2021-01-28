require 'json'

class SentryEvent
  def initialize(json)
    @json = json
  end

  def project
    @json['project']
  end

  def culprit
    @json['culprit']
  end

  def message
    @json['message']
  end

  def url
    @json['url']
  end

  def environment
    @json['event']['environment']
  end
end