require 'terrapin'

class YoutubeDL
  class ImportError < StandardError; end

  class Media
    attr_reader :url, :title

    def initialize(url)
      if url.nil? || url.empty?
        raise ArgumentError, 'url cannot be nil or empty'
      end

      @url = url
    end

    def valid?
      fetch_info if valid.nil?
      valid
    end

    def import(outdir:)
      line = Terrapin::CommandLine.new(
        'youtube-dl', ":url --extract-audio --audio-format mp3 -o :out",
        expected_outcodes: [0]
      )
      
      begin
        line.run(
          url: url,
          out: "#{outdir}/%(title)s.%(ext)s"
        )
      rescue Terrapin::ExitStatusError
        raise YoutubeDL::ImportError
      end
    end

    private
    attr_reader :valid

    def fetch_info
      line = Terrapin::CommandLine.new(
        'youtube-dl', ":url -j",
        expected_outcodes: [0]
      )

      begin
        info = line.run(url: url)
        info = JSON.parse(info)
      rescue Terrapin::ExitStatusError
        @valid = false
        return
      end

      @valid = true
      @title = info['title']
    end
  end
end