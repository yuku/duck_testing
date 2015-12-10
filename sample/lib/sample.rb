require "concern"

class Sample
  include Concern

  # Duplicate some text an arbitrary number of times.
  #
  # @param text [String] the string to be duplicated.
  # @param count [Integer] the integer number of times to duplicate the `text`.
  # @return [String] the duplicated string.
  def multiplex(text, count)
    text * count
  end
end
