require 'rspec/expectations'
include RSpec::Matchers

module ISBNVerifier
  # Module for ISBN13 validation.
  def self.validate(number)
    # Returns a valid ISBN13 number or raise an error if a 12/13 digits long number isn't provided.
    
    # `number` must be an Integer
    if !number.is_a?(Integer)
      raise "Expected an Integer, however #{number.class} was given."
    end

    # Coerces number type into string
    number = number.to_s
    
    # Verifies wether provided number has a valid length.
    # `number.size` can be 12 or 13 digitsg long, since number may contain check digit
    if number.size < 12 || number.size > 13
      raise "Invalid ISBN number size. "\
            "Should be 12 or 13 digits long, but #{number.size} digits were provided."
    end

    # Verifies wether provided number has check digit
    if number.size == 13
      number = number[0..11]
    end

    check_digit = get_check_digit(number)
    return "#{number}-#{check_digit}"
  end

  def self.get_check_digit(isbn_number)
    char_count = 1
    total_sum = isbn_number.chars.reduce(0) {
    |sum, digit|
      # Checks digit position's parity in order to determine the multiplier
      multiplier = char_count % 2 == 0 ? 3 : 1
      char_count += 1
      # Sums the partial total with the next digit
      sum.to_i + digit.to_i * multiplier
    }
    # Normalizes number in 1-digit length
    isbn_digit = 10 - total_sum % 10
    return isbn_digit == 10 ? "0" : isbn_digit.to_s;
  end
end

# Error handling
expect{ISBNVerifier.validate(97801430072)}.to raise_error(RuntimeError)
expect{ISBNVerifier.validate(97801430072344)}.to raise_error(RuntimeError)
expect{ISBNVerifier.validate("921092")}.to raise_error(RuntimeError)

# Equivalences
expect(ISBNVerifier.validate(978014300723)).to eq "978014300723-4"
expect(ISBNVerifier.validate(748174308791)).to eq "748174308791-7"