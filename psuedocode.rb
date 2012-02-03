#def multiply(a, b, sum)
  #if b == 0
    #return sum
  #else
    #sum += a
    #b -= 1
    #return multiply(a, b, sum)
  #end
#end

#def power(a, b, product)
  #if b == 0
    #return product
  #else
    #product = multiply(a, product, 0)
    #b -= 1
    #return power(a, b, product)
  #end
#end

def multiply(a, b)
  if b == 0
    return 0
  elsif a == 0
    return 0
  elsif b == 1
    return a
  elsif a == 1
    return b
  else
    b = b - 1
    prod = a + multiply(a, b)
    return prod
  end
end

def power(base, exp)
  if exp == 0
    return 1
  elsif base == 0
    return 0
  elsif exp == 1
    return base
  else
    exp = exp - 1
    decr_power = power(base, exp)
    prod = multiply(base, decr_power)
    return prod
  end
end

puts "3 x 3 = #{multiply(3, 3)}"

puts "0 x 5 = #{multiply(0, 5)}"

puts "6 x 0 = #{multiply(6, 0)}"

puts "1 x 2 = #{multiply(1, 2)}"

puts "7 x 1 = #{multiply(7, 1)}"

puts "1^1 = #{power(1, 1)}"

puts "1^3 = #{power(1, 3)}"

puts "4^1 = #{power(4, 1)}"

puts "2^2 = #{power(2, 2)}"

puts "3^2 = #{power(3, 2)}"

puts "0^1 = #{power(0, 1)}"

puts "0^2 = #{power(0, 2)}"

puts "1^0 = #{power(1, 0)}"

puts "9^0 = #{power(9, 0)}"

puts "4^3 = #{power(4, 3)}"

puts "0^0 = #{power(0, 0)}"
