module FileConverter
  class FileService
    def initialize(file_path, data)
      @file_path = file_path
      @data = data
    end

    def create
      f = File.new(@file_path, "w")
      f.write(@data)
      f.close
      puts "Json file created successfully. You can view it here: #{@file_path}"
    rescue StandardError => error
      puts error.message
    end
  end
end
