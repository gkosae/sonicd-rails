class Config
  class << self
    def import_root
      ENV.fetch('IMPORT_ROOT_DIR')
    end
  end
end
