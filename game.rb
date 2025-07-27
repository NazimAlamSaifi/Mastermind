class Mastermind
  COLORS = %w[red blue green yellow orange purple]
  CODE_LENGTH = 4

  def play
    puts "Welcome to Mastermind!"
    puts "Available colors: #{COLORS.join(', ')}"
    puts "-" * 40
    print "Do you want to (g)uess or (m)ake the code? "
    choice = gets.chomp.downcase

    if choice == 'g'
      play_as_guesser
    elsif choice == 'm'
      play_as_maker
    else
      puts "Invalid choice. Please restart."
    end
  end

  def play_as_guesser
  

    loop do
      print "Enter your guess (comma-separated): "
      guess = gets.chomp.downcase.strip.split(",").map(&:strip)

      if valid_guess?(guess)
        exact, color_only = feedback(guess, secret_code)
        puts "Exact matches: #{exact}, Color-only matches: #{color_only}"

        if exact == CODE_LENGTH
          puts "🎉 You cracked the code! It was: #{guess.join(', ')}"
          break
        end
      else
        puts "❌ Invalid guess. Use #{CODE_LENGTH} colors from: #{COLORS.join(', ')}"
      end
    end
  end

  def play_as_maker
    print "Enter your secret code for the computer to guess (comma-separated): "
    code = gets.chomp.downcase.strip.split(",").map(&:strip)

    unless valid_guess?(code)
      puts "❌ Invalid code. Use #{CODE_LENGTH} colors from: #{COLORS.join(', ')}"
      return
    end

    puts "\n🤖 Computer will now try to guess your code..."

    possible_guesses = COLORS.repeated_permutation(CODE_LENGTH).to_a
    attempts = 0

    loop do
      guess = possible_guesses.shift
      attempts += 1
      puts "🤖 Attempt #{attempts}: #{guess.join(', ')}"

      print "Enter feedback (exact,color-only): "
      feedback_input = gets.chomp.strip
      if feedback_input =~ /^\d+,\d+$/
        exact, color_only = feedback_input.split(",").map(&:to_i)

        if exact == CODE_LENGTH
          puts "🎉 Computer cracked your code in #{attempts} attempts!"
          break
        end

        possible_guesses.select! do |candidate|
          feedback(candidate, guess) == [exact, color_only]
        end
      else
        puts "Invalid feedback format. Enter like: 2,1"
      end
    end
  end

  private

  def valid_guess?(guess)
    guess.length == CODE_LENGTH && guess.all? { |color| COLORS.include?(color) }
  end

  def feedback(guess, code)
    exact = 0
    color_only = 0

    code_clone = code.dup
    guess_clone = guess.dup

    CODE_LENGTH.times do |i|
      if guess[i] == code[i]
        exact += 1
        code_clone[i] = nil
        guess_clone[i] = nil
      end
    end

    guess_clone.compact.each do |color|
      if code_clone.include?(color)
        color_only += 1
        code_clone[code_clone.index(color)] = nil
      end
    end
  
    [exact, color_only]
  end
 
end

Mastermind.new.play