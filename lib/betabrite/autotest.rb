require 'betabrite'

module Autotest::BetaBrite
  @@first_run = true

  def self.hook(klass, *args, &block)
    Autotest.add_hook :ran_command do |at|
      if at.results.last =~ /^.* (\d+) failures, (\d+) errors$/
        bb = klass.new(*args) do |sign|
          sign.allocate do |memory|
            memory.text('A', 4096)
            memory.string('0', 128)
            memory.string('1', 128)
          end

          failures  = BetaBrite::String.new("#{$1} failures").red
          errors    = BetaBrite::String.new("#{$2} errors").red
          failures.green if $1 == '0'
          errors.green if $2 == '0'
          block.call(failures, errors) if block

          sign.stringfile('0') do
            print failures
          end
          sign.stringfile('1') do
            print errors
          end

          if @@first_run
            sign.textfile do
              print stringfile('0')
              print " "
              print stringfile('1')
            end
          end
        end
        bb.write_memory! if @@first_run
        bb.write!
        @@first_run = false if @@first_run
      end
    end
  end
end
