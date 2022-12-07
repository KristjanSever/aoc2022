require_relative './fileobject'

input = File.open("input.txt").readlines

TOTAL_SPACE = 70_000_000
SPACE_NEEDED = 30_000_000

SMALLEST_DIR_SIZE = 100_000
root = FileObject.new(nil, "/", :dir)
current_dir = root

input.each do |line|
  line.strip!
  if line.start_with?("$")
    command, location = line.split(" ")[1..]
    current_dir = current_dir.change_dir_to(location) if command == "cd"
    next
  end

  type_or_size, fileobject_name = line.split(" ")

  next if current_dir.element_exists?(fileobject_name)

  current_dir.create_new(type_or_size, fileobject_name)
end

@total_sum = 0
def check_all_dirs(obj, space_needed)
  # task 1
  @total_sum += obj.objects_size if obj.objects_size <= SMALLEST_DIR_SIZE

  # task 2
  if obj.objects_size >= space_needed
    @smallest_possible ||= obj
    @smallest_possible = obj if obj.objects_size < @smallest_possible.objects_size
  end

  dirs = obj.objects.select { |fo| fo.type == :dir }

  dirs.each do |dir|
    check_all_dirs(dir, space_needed)
  end
end

free_space_needed = SPACE_NEEDED - (TOTAL_SPACE - root.objects_size)

check_all_dirs(root, free_space_needed)
puts("task1 total sum: #{@total_sum}")

puts("task2 smallest large enough dir: #{@smallest_possible.objects_size}")
