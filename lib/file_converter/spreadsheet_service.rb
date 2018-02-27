require 'roo'

module FileConverter
  class SpreadsheetService
    def initialize(file)
      @file = file
    end

    def read
      Roo::Spreadsheet.open(@file, extension: :xlsx)
    end
  end
end
