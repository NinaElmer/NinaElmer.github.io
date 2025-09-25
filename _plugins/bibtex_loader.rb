# _plugins/bibtex_loader.rb
require 'bibtex'
require 'fileutils'

module Jekyll
  class BibtexGenerator < Generator
    safe true
    priority :high

    def generate(site)
      bib_file = File.join(site.source, '_bibliography', 'publications.bib')
      unless File.exist?(bib_file)
        puts "No BibTeX file found at #{bib_file}"
        return
      end

      puts "Bib file found: #{bib_file}"

      bib = BibTeX.open(bib_file)
      puts "Total entries in BibTeX: #{bib.size}"

      site.data['publications'] ||= {}
      site.data['publications']['index'] ||= []
      site.data['publications']['featured'] ||= []

      # Directory in source tree for generated BibTeX files
      cite_source_dir = File.join(site.source, "publications", "citations")
      FileUtils.mkdir_p(cite_source_dir)

      bib.each do |entry|
        next unless entry.is_a?(BibTeX::Entry)

        authors = entry[:author].to_s.strip
        authors = "Unknown Author" if authors.nil? || authors.empty?

        title = entry[:title].to_s.strip
        title = "No Title" if title.nil? || title.empty?

        year = entry[:year].to_s.to_i rescue 0
        citation = "#{authors} (#{year}). #{title}."

        # Detect arXiv link
        eprint = entry[:eprint].to_s
        url    = entry[:url].to_s
        arxiv  = if !eprint.empty?
                   eprint.start_with?('http') ? eprint : "https://arxiv.org/abs/#{eprint}"
                 elsif url.include?('arxiv.org')
                   url
                 else
                   ''
                 end

        # Detect PDF: prefer explicit PDF, fallback to arXiv PDF
        pdf = entry[:file].to_s
        pdf = entry[:pdf].to_s if pdf.empty?
        pdf = entry[:url].to_s if pdf.empty? && entry[:url].to_s.end_with?('.pdf')
        pdf = "https://arxiv.org/pdf/#{eprint}.pdf" if pdf.empty? && !eprint.empty?

        # Create safe BibTeX filename
        safe_key = entry.key.gsub(/[:\/\\?]/, "_")
        cite_filename = "#{safe_key}.bib"
        cite_path = File.join(cite_source_dir, cite_filename)
        File.open(cite_path, "w") { |f| f.puts entry.to_s }

        # Add to Jekyll static_files so it is copied to _site
        site.static_files << Jekyll::StaticFile.new(site, site.source, "publications/citations", cite_filename)
        cite = "/publications/citations/#{cite_filename}"

        # Add to site.data
        site.data['publications']['index'] << {
          'name' => citation,
          'pdf' => pdf,
          'arxiv' => arxiv,
          'cite' => cite,
          'year' => year
        }

        puts "Processing entry: {#{title}}"
      end

      # Sort descending by year
      site.data['publications']['index'].sort_by! { |p| -(p['year'] || 0) }

      # Top 3 featured
      site.data['publications']['featured'] = site.data['publications']['index'][0..2]

      puts "Total publications loaded: #{site.data['publications']['index'].size}"
      puts "Top featured publications:"
      site.data['publications']['featured'].each do |f|
        puts "- #{f['name']}"
      end
    end
  end
end
