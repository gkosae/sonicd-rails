require 'terrapin'
require 'securerandom'
require 'json'
require 'fileutils'

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
      outdir = "#{outdir}/" unless outdir.end_with?('/')
      FileUtils.mkdir_p(outdir)

      download = Terrapin::CommandLine.new(
        'youtube-dl', '-i --extract-audio --audio-format mp3 -o :out -- :url',
        expected_outcodes: [0]
      )

      move = Terrapin::CommandLine.new(
        'mv', ':audio :dest',
        expected_outcodes: [0]
      )

      begin
        download.run(
          url: url,
          out: "#{tmp_dir}/%(title)s.%(ext)s"
        )

        move.run(
          audio: Dir.glob("#{tmp_dir}/*.mp3").first,
          dest: outdir
        )

        clear_tmp_dir
      rescue Terrapin::ExitStatusError
        raise YoutubeDL::ImportError
      end
    end

    def clear_tmp_dir
      FileUtils.rm_rf(tmp_dir)
    end

    private

    attr_reader :valid, :meta

    def check_link
      FileUtils.mkdir_p(tmp_dir)

      line = Terrapin::CommandLine.new(
        'youtube-dl', ' -j --flat-playlist -- :url > :meta_file',
        expected_outcodes: [0]
      )

      begin
        line.run(url: url, meta_file: tmp_meta_file)
        @valid = true
      rescue Terrapin::ExitStatusError
        @valid = false
        nil
      end
    end

    def tmp_meta_file
      "#{tmp_dir}/meta.json"
    end

    def tmp_dir
      "/tmp/sonicd/#{uuid}"
    end

    def fetch_meta
      line = Terrapin::CommandLine.new(
        'youtube-dl', '-j -- :url',
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
