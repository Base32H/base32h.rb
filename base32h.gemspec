lib = File.expand_path('../lib/', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'base32h'

Gem::Specification.new do |s|
  s.name        = 'base32h'
  s.version     = Base32H::VERSION
  s.date        = '2020-10-25'
  s.summary     = 'Base32H'
  s.description = 'An encoder/decoder library for Base32H'
  s.author      = 'Ryan S. Northrup ("RyNo")'
  s.email       = 'northrup@yellowapple.us'
  s.files       = ['lib/base32h.rb', 'README.md', 'COPYING']
  s.homepage    = 'https://base32h.github.io'
  s.license     = 'ISC'
  
  s.add_development_dependency 'rspec'

  s.metadata = {
    'homepage_uri'    => 'https://base32h.github.io',
    'source_code_uri' => 'https://github.com/base32h/base32h.rb'
  }
end
