#!/usr/bin/env ruby
require 'bibtex'
require 'yaml'
require 'fileutils'

# Load BibTeX
bib_file = "_bibliography/publications.bib"
bib = BibTeX.open(bib_file)

# Prepare output
publications = { 'index' => [], 'featured' => [] }

bib.each do |entry|
  next unless entry.is_a?(BibTeX::Entry)

  authors = entry[:author].to_s.strip
  authors = "Unknown Author" if authors.empty?

  title = entry[:title].to_s.strip
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
