require 'betabrite'

module Autotest::BetaBrite
  def self.hook(klass, *args, &block)
    Autotest.add_hook :ran_command do |at|
      if at.results.last =~ /^.* (\d+) failures, (\d+) errors$/
        bb = klass.new(*args) do |sign|
          sign.textfile do
            failures  = string("#{$1} failures").red
            errors    = string(" #{$2} errors").red
            failures.green if $1 == '0'
            errors.green if $2 == '0'
            block.call(failures, errors) if block
            print failures
            print errors
          end
        end
        bb.write!
      end
    end
  end
end
