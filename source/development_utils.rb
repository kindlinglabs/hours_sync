begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

begin
  require 'byebug'
rescue LoadError
end

begin
  require 'awesome_print'
rescue LoadError
end
