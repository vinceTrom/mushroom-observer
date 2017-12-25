# class with information about external websites
class WebSequenceArchive
  class << self

    # on-line primary-source repositories (Archives) for nucleotide sequences
    # in menu order
    #   name    short name, used in drop-down menu
    #   home    home page
    #   prefix  prefix for Accession (When Accession is appended to this,
    #           it will land on the page for that Accession in the Archive.)
    def archives
      [
        { name:   "GenBank",
          home:   "https://www.ncbi.nlm.nih.gov/genbank/",
          prefix: "https://www.ncbi.nlm.nih.gov/nuccore/" },
        { name:   "ENA",
          home:   "http://www.ebi.ac.uk/ena",
          prefix: "http://www.ebi.ac.uk/ena/data/view/" },
        { name:   "UNITE",
          home:   "https://unite.ut.ee/",
          prefix: "https://unite.ut.ee/search.php?qresult=yes&accno=" }
      ]
    end

    def all_archives
      archives.map { |archive| archive[:name] }
    end

    def valid_archive?(str)
      archives.each do |archive|
        return archive.name if archive[:name].casecmp(str).zero?
      end
      nil
    end

    # return the archive hash for the named archive
    def archive(name)
      archives.find { |archive| archive[:name] == name }
    end

    def archive_home(name)
      archive(name)[:home]
    end

    def search_prefix(name)
      archive(name)[:prefix]
    end

    def blast_format_help
      "https://blast.ncbi.nlm.nih.gov/Blast.cgi?"\
      "CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=BlastHelp"
    end
  end
end
