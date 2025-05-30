require 'pathname'
require 'fileutils'
require 'json'
require_relative './src/carousel_parser'

def get_html_files
  html_files_dir = Pathname.new(__dir__).join('files').realpath
  Dir.entries(html_files_dir).select { |f| File.file?(File.join(html_files_dir, f)) && f.end_with?('.html') }
end

def process_html_files
  html_files_dir = Pathname.new(__dir__).join('files').realpath
  output_dir = Pathname.new(__dir__).join('output')

  output_dir.mkpath

  get_html_files.each do |filename|
    file_path = File.join(html_files_dir, filename)
    html_content = File.read(file_path)

    parser = CarouselParser.new
    result = parser.parse(html_content)

    output_filename = filename.sub('.html', '.json')
    output_path = output_dir.join(output_filename)

    File.write(output_path, JSON.pretty_generate(result))
  end
end

process_html_files
