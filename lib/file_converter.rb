require 'roo'
require 'pry'
require 'pdfkit'
require 'json'
require_relative './file_converter/spreadsheet_service'
require_relative './file_converter/file_service'

module FileConverter
  class Converter
    def initialize(spreadsheet_path)
      @spreadsheet_path = spreadsheet_path
    end

    def read
      @spreadsheet_rows = []
      @spreadsheet = SpreadsheetService.new(@spreadsheet_path).read
      @spreadsheet.sheet(0).each do |row|
        @spreadsheet_rows << row
      end
      @spreadsheet_rows
    end

    def generate_table_head
      header_row = @spreadsheet_rows[0]
      table_head = "<tr>"
      header_row.each do |data|
        table_head += "<th>" + data + "</th>"
      end
      table_head += "</tr>"
      table_head
    end

    def generate_html_table
      @table = "<html><body><table style='width:100%'>"
      @table += generate_table_head
      @spreadsheet_rows.each_with_index do |row, index|
        next if index == 0
        @table += "<tr>"
        row.each do |data|
          @table += "<td>" + data + "</td>"
        end
        @table += "</tr>"
      end
      @table += "</table></body></html>"
      @table
    end

    def to_pdf(pdf_path)
      generate_html_table
      kit = PDFKit.new(@table)
      kit.to_file(pdf_path)
    end

    def generate_hash
      header = @spreadsheet_rows[0]
      spreadsheet_hash = {}
      header.each_with_index do |data, index|
        head_index = index
        spreadsheet_hash[data] = []
        @spreadsheet_rows.each_with_index do |row_data, index|
          next if index == 0
          spreadsheet_hash[data] << row_data[head_index]
        end
      end
      spreadsheet_hash
    end

    def to_json(json_path)
      json_data = JSON.pretty_generate(generate_hash)
      FileService.new(json_path, json_data).create
    end
  end
end

spreadsheet_path = File.join(Dir.pwd,'lib/public','sample-speadsheet.xlsx')
pdf_path = File.join(Dir.pwd,'lib/public','sample-pdf.pdf')
json_path = File.join(Dir.pwd,'lib/public','sample-json.json')

obj = FileConverter::Converter.new(spreadsheet_path)
obj.read
obj.to_pdf(pdf_path)
obj.to_json(json_path)

