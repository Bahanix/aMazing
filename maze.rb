require 'fileutils'

class Maze < Array
  def generate
    0.upto(self.size - 1) do |i|
      self[i] = { :name => i, :value => i, :path => "%0#{size.to_s.length}d" % i }
    end
    self.each do |current|
      break if self.are_all_the_same?
      dest = self.pick_one_but_not(current[:value])
      current[:value] = dest[:value]
      self.update_paths(current, dest[:path] + '/' + current[:path])
    end
    self
  end

  def build(root)
    FileUtils.rm_rf root
    self.each do |current|
      FileUtils.mkdir_p root + '/' + current[:path]
    end
  end

  protected

  def are_all_the_same?
    self.all?{|v| v[:value] == self.first[:value]}
  end

  def pick_one_but_not(i)
    tmp = self.reject{|v| v[:value] == i}
    self[tmp[(tmp.size * rand).floor][:name]]
  end

  def update_paths(current, new_path)
    self[0..current[:name]].each do |o|
      if o[:path].gsub!(current[:path], new_path)
        o[:value] = current[:value]
      end
    end
  end
end

size = ARGV[0].to_i
if size > 0
  root = ARGV[1] || 'root'
  Maze.new(size).generate.build(root)
else
  puts 'Size must be greater than 0.'
end
