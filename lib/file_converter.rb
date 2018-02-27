require 'roo'
require 'pry'
require_relative './file_converter/spreadsheet_service'

module FileConverter
  class File
    def initialize(file)
      @file = file
    end

    def read
      @array_of_rows = []
      f = SpreadsheetService.new(@file).read
      f.sheet(0).each do |row|
        @array_of_rows << row
      end
      @array_of_rows
    end

    def write
    end
  end
end

file_path = File.join(Dir.pwd,'lib/public','sample-speadsheet.xlsx')
obj = FileConverter::File.new(file_path)
obj.read

