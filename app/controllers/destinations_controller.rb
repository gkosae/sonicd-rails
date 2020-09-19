class DestinationsController < ApplicationController
  def index
    destinations = Dir.glob("#{Config.import_root}/**/*")
      .select { |f| File.directory?(f)}
      .map {|f| f.gsub("#{Config.import_root}/", '')}
      .sort

    json_response(destinations: destinations)
  end
end