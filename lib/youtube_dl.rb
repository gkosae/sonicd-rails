require 'terrapin'
require 'securerandom'
require 'json'

class YoutubeDL
  class ImportError < StandardError; end

  class Media
    attr_reader :url, :uuid

    def initialize(url, uuid: nil)
      raise ArgumentError, 'url cannot be nil or empty' if url.nil? || url.empty?

      @uuid = uuid || SecureRandom.uuid
      @url = url
    end

    def valid?
      check_link if valid.nil?
      valid
    end

    def title
      unless @title
        if playlist?
          @title = 'Playlist'
        else
          fetch_meta
          @title = meta['title']
        end
      end

      @title
    end

    def playlist_urls
      return [] unless playlist?

      File.readlines(tmp_meta_file).map do |line|
        JSON.parse(line)['url']
      end
    end

    def playlist?
      return false unless valid?

      line_count = `wc -l #{tmp_meta_file}`.strip.split(' ')[0].to_i
      line_count > 1
    end

    def import(outdir:)
      line = Terrapin::CommandLine.new(
        'youtube-dl', ':url -i --extract-audio --audio-format mp3 -o :out',
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

    attr_reader :valid, :meta

    def check_link
      line = Terrapin::CommandLine.new(
        'youtube-dl', ":url -j --flat-playlist > #{tmp_meta_file}",
        expected_outcodes: [0]
      )

      begin
        line.run(url: url)
        @valid = true
      rescue Terrapin::ExitStatusError
        @valid = false
        nil
      end
    end

    def tmp_meta_file
      "/tmp/#{uuid}.json"
    end

    def fetch_meta
      line = Terrapin::CommandLine.new(
        'youtube-dl', ':url -j',
        expected_outcodes: [0]
      )

      begin
        info = line.run(url: url)
        @meta = JSON.parse(info)
      rescue Terrapin::ExitStatusError
        nil
      end
    end
  end
end
