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

  def root
    tmp = self
    tmp = tmp.parent until tmp.parent.nil?
    tmp
  end

  def change_dir_to(location)
    return root if location == "/"

    return parent if location == ".."

    objects.find { |fo| fo.name == location }
  end

  def element_exists?(fileobject_name)
    !objects.find { |fo| fo.name == fileobject_name }.nil?
  end

  def create_new(type_or_size, name)
    if type_or_size == "dir"
      add_object(name, :dir)
      return
    end

    add_object(name, :file, type_or_size.to_i)
  end
end
