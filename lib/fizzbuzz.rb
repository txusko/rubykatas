def fizzbuzz
  (0..100).each do |num|
    fizz = (num % 3).zero? || num.to_s.include?('3')
    buzz = (num % 5).zero? || num.to_s.include?('5')
    print 'Fizz' if fizz
    print 'Buzz' if buzz
    print num if !fizz && !buzz
    puts
  end
end

fizzbuzz
