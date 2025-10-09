#!/usr/bin/env ruby
require 'bibtex'
require 'yaml'
require 'fileutils'

# Simple LaTeX to UTF-8 converter
def latex_to_utf8(str)
  return '' if str.nil?

  mapping = {
    # Accents
    '\\"a' => 'ä', '\\"o' => 'ö', '\\"u' => 'ü', '\\"A' => 'Ä', '\\"O' => 'Ö', '\\"U' => 'Ü',
    "\\'a" => 'á', "\\'e" => 'é', "\\'i" => 'í', "\\'o" => 'ó', "\\'u" => 'ú',
    "\\'A" => 'Á', "\\'E" => 'É', "\\'I" => 'Í', "\\'O" => 'Ó', "\\'U" => 'Ú',
    "\\`a" => 'à', "\\`e" => 'è', "\\`i" => 'ì', "\\`o" => 'ò', "\\`u" => 'ù',
    "\\`A" => 'À', "\\`E" => 'È', "\\`I" => 'Ì', "\\`O" => 'Ò', "\\`U" => 'Ù',
    "\\^a" => 'â', "\\^e" => 'ê', "\\^i" => 'î', "\\^o" => 'ô', "\\^u" => 'û',
    "\\^A" => 'Â', "\\^E" => 'Ê', "\\^I" => 'Î', "\\^O" => 'Ô', "\\^U" => 'Û',
    "\\~n" => 'ñ', "\\~N" => 'Ñ',
    "\\c{c}" => 'ç', "\\c{C}" => 'Ç',

    # Symbols
    '--' => '—', # em dash
    '---' => '—', # em dash
    "\\&" => '&'
  }

  mapping.each { |latex, utf8| str = str.gsub(latex, utf8) }
  str
end

# Load BibTeX
bib_file = "_bibliography/publications.bib"
bib = BibTeX.open(bib_file)

# Prepare output
publications = { 'index' => [], 'featured' => [] }

bib.each do |entry|
  next unless entry.is_a?(BibTeX::Entry)

  authors = latex_to_utf8(entry[:author].to_s.strip)
  authors = "Unknown Author" if authors.empty?

  title = latex_to_utf8(entry[:title].to_s.strip)
  title = "No Title" if title.empty?

  year = entry[:year].to_s.to_i rescue 0
  citation = "#{authors} (#{year}). #{title}."

  # Detect PDF
  pdf = entry[:file].to_s
  pdf = entry[:pdf].to_s if pdf.empty?
  pdf = entry[:url].to_s if pdf.empty? && entry[:url].to_s.end_with?('.pdf')
  eprint = entry[:eprint].to_s
  pdf = "https://arxiv.org/pdf/#{eprint}.pdf" if pdf.empty? && !eprint.empty?

  # Detect arXiv
  arxiv = if !eprint.empty?
            eprint.start_with?('http') ? eprint : "https://arxiv.org/abs/#{eprint}"
          elsif entry[:url].to_s.include?('arxiv.org')
            entry[:url].to_s
          else
            ''
          end

  # Detect DOI/Cite
  doi = entry[:doi].to_s
  cite = doi.empty? ? '' : (doi.start_with?('http') ? doi : "https://doi.org/#{doi}")

  publications['index'] << {
    'name' => citation,
    'pdf' => pdf,
    'arxiv' => arxiv,
    'cite' => cite,
    'year' => year
  }
end

# Sort descending by year
publications['index'].sort_by! { |p| -p['year'] }

# Top 3 featured
publications['featured'] = publications['index'][0..2]

# Save YAML file
FileUtils.mkdir_p("_data")
File.open("_data/publications.yml", "w") do |f|
  f.write(publications.to_yaml)
end

puts "Generated _data/publications.yml with #{publications['index'].size} entries."
