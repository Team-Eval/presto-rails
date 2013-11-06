class Presto

  PRESTO_ROOT = File.expand_path('../', File.dirname(__FILE__))
  def self.run
    if ARGV[0].nil? || ['-h','--help'].include?(ARGV[0])
      puts <<-HELP
      Usage:
        presto <app_name>
      HELP
    else
      system("rails new #{ARGV[0]} -Tm #{PRESTO_ROOT}/templates/flatiron.rb")
    end
  end
  
end