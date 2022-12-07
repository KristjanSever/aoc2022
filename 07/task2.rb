require 'set'
input = File.open("input.txt").readlines

class FileObject
  attr_accessor :name, :parent, :type, :objects, :objects_size, :select
  def initialize(parent, name, type, size = 0)
    @parent = parent
    @name = name
    @type = type
    @size = size
    return if type == :file

    @objects = []
    @objects_size = 0
  end

  def add_object(name, type, size = 0)
    fo = FileObject.new(self, name, type, size)
    @objects.append(fo)

    tmp = self
    loop do
      tmp.objects_size += size
      tmp = tmp.parent
      break if tmp.nil?
    end
    fo
  end
end

root = FileObject.new(nil, "/", :dir)
current_dir = root
ls_mode = false
input.each do |line|
  line.strip!
  if line.start_with?("$")
    command, location = line.split(" ")[1..]
    if command == "cd"
      if location == "/"
        current_dir = root
        next
      end
      if location == ".."
        current_dir = current_dir.parent
        next
      end
      current_dir = current_dir.objects.find { |fo| fo.name == location }
    else
      ls_mode = true
    end
    next

  end

  type_or_size, name = line.split(" ")
  el = current_dir.objects.find { |fo| fo.name == name }
  next if el

  if type_or_size == "dir"
    current_dir.add_object(name, :dir)
  else
    current_dir.add_object(name, :file, type_or_size.to_i)
  end
end

@biggest = {size: 0, name: nil}
def biggest(obj)
  @suma += obj.objects_size if obj.objects_size <= 100_000
  dirs = obj.objects.select { |fo| fo.type == :dir }

  dirs.each do |dir|
    sum(dir)
  end
end
sum(root)
puts @suma