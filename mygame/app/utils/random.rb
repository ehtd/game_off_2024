# frozen_string_literal: true

def random(min, max)
  min = Integer(min)
  max = Integer(max)
  rand((max + 1) - min) + min
end

def fisher_yates_shuffle(array)
  n = array.length
  (n - 1).downto(1) do |i|
    j = random(0, i) # Random index from 0 to i
    array[i], array[j] = array[j], array[i] # Swap elements
  end
  array
end
