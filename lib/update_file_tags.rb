require 'taglib'

# Update audio file title and album tags.
# title = filename - extension
# album = File directory relative to root of audio file store
class UpdateFileTags
  class << self
    def call(root_dir, incremental: true)
      @root_dir = root_dir
      @incremental = incremental

      Dir.glob("#{root_dir}/**/*.mp3").each do |file|
        update_tags(file)
      end
    end

    private

    def update_tags(file)
      TagLib::FileRef.open(file) do |ref|
        next if ref.null? || (@incremental && ref.tag.title.present?)

        ref.tag.title = filename(file).gsub('.mp3', '')
        ref.tag.album = dir(file).gsub('/', ' - ')
        ref.save
      end
    end

    def dir(file)
      (relative_path(file).split - [filename(file)]).join('/')
    end

    def filename(file)
      relative_path(file).split('/').last
    end

    def relative_path(file)
      file.gsub("#{@root_dir}/", '')
    end
  end
end
