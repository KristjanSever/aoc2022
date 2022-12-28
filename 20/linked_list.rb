class Node
  attr_accessor :next, :prev
  attr_reader   :value, :index

  def initialize(value, index, next_ = nil, prev = nil)
    @value = value
    @index = index
    @prev = prev
    @next = next_
  end
  def to_s
    "Node with value: #{@value}"
  end
  def to_i
    @value
  end

  def move_right_i_times(i)
    self.prev.next = self.next
    self.next.prev = self.prev
    tmp = self
    i.times do
      tmp = tmp.next
    end
    self.prev = tmp
    self.next = tmp.next
    self.next.prev = self
    tmp.next = self
  end

  def move_left_i_times(i)
    self.prev.next = self.next
    self.next.prev = self.prev
    tmp = self
    (i+1).times do
      tmp = tmp.prev
    end
    self.prev = tmp
    self.next = tmp.next
    self.next.prev = self
    tmp.next = self
  end

  def move(i, size)
    i = i % (size - 1)
    return if i == 0

    move_right_i_times(i)
  end

  def print
    string = ""
    string += self.to_i.to_s
    tmp = self.next
    while tmp != self
      string += ",#{tmp.to_i}"
      tmp = tmp.next
    end
    puts string
  end
end
