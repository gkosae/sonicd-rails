require 'taglib'

class UpdateFileTags
  class << self
    def call(root_dir)
      Dir.glob("#{root_dir}/**/*.mp3")
        .each do |file|
          update_tags(file, root_dir)
        end
    end

    def update_tags(file, root_dir)
      TagLib::FileRef.open(file) do |ref|
        relative_path = file.gsub("#{root_dir}/", '')
        attrs = relative_path.split('/')
        filename = attrs.last
        dir = (attrs - [filename]).join('/')

        if ref.null?
          # Skip
        elsif ref.tag.title.present?
          # Skip
        else
          tag = ref.tag
          tag.title = filename.gsub('.mp3', '')
          tag.album = dir.gsub('/', ' - ')
          ref.save
        end
      end
    end
  end
end