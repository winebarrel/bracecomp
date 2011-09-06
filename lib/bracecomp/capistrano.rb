require 'bracecomp'

class BraceComp::Capistrano
  def self.expand_env(name)
    return unless ENV[name]
    ENV[name] = ENV[name].expand.map {|i| i.split(',') }.flatten.uniq.join(',')
  end
end

BraceComp::Capistrano.expand_env('ROLES')
BraceComp::Capistrano.expand_env('HOSTS')
