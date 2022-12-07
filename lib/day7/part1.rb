require 'csv'
require 'pp'
require 'ostruct'

module Day7
  class Node
    attr_accessor :name, :parent, :children, :size

    def initialize(name, parent, size = nil)
      @name = name
      @parent = parent
      @children = []
      @size = size
    end

    def nodes
      [self] + children.flat_map(&:nodes)
    end

    def find_or_add_child(name, size = nil)
      existing_child = children.find { |c| c.name == name }
      return existing_child if existing_child

      child = Node.new(name, self, size)
      children.push(child)
      child
    end

    def calculate_sizes!
      return size if size
      @size = children.map(&:calculate_sizes!).sum
    end

    def leaf?
      children.empty?
    end

    def to_s
      depth_string(0)
    end

    def depth_string(depth)
      base = "  " * depth + "- #{name} (#{size})"
      child_string = children.map { |c| "\n" + c.depth_string(depth+1) }.join
      base + child_string
    end
  end

  class Part1
    def run(input_file)
      lines = File.readlines(input_file).each
      tree = build_tree(lines)
      tree.calculate_sizes!

      puts tree
      dir_sizes = tree.nodes.select { |n| !n.leaf?}.map(&:size)
      pp dir_sizes
      puts dir_sizes.select { |s| s < 100000 }.sum
      nil
    end

    def build_tree(lines)
      root_node = Node.new("/", nil)
      current_node = root_node

      loop do
        line = lines.next
        _, cmd, arg = line.split
        if cmd == "cd"
          if arg == ".."
            current_node = current_node.parent
          else
            current_node = current_node.find_or_add_child(arg)
          end
        elsif cmd == "ls"
          while(true) do
            line = lines.next
            detail, file = line.split
            size = detail == "dir" ? nil : detail.to_i
            current_node.find_or_add_child(file, size)
            break if lines.peek =~ /\$/
          end
        end
      end

      root_node
    end
  end
end
