require 'pathname'
require 'fileutils'
require 'json'
require_relative './src/parser1'
require_relative './src/parser2'

PROCESSOR_MAP = {
  "van-gogh-paintings.html" => Parser1,
  "how-to-tie-a-tie.html" => Parser2,
  "pasta-recipes.html" => Parser2
}

def get_html_files
  html_files_dir = Pathname.new(__dir__).join('files').realpath
  Dir.entries(html_files_dir).select { |f| File.file?(File.join(html_files_dir, f)) && f.end_with?('.html') }
end

def process_html_files
  html_files_dir = Pathname.new(__dir__).join('files').realpath
  output_dir = Pathname.new(__dir__).join('output')

  get_html_files.each do |filename|
    processor = PROCESSOR_MAP[filename]

    unless processor
      puts "No processor found for #{filename}"
      next
    end

    file_path = File.join(html_files_dir, filename)
    html_content = File.read(file_path)
    result = processor.process(html_content)

    puts "Processed #{filename} with #{processor}"

    output_filename = filename.sub('.html', '.json')
    output_path = output_dir.join(output_filename)

    File.write(output_path, JSON.pretty_generate(result))
    puts "Saved result to #{output_path}"
  end
end

process_html_files
