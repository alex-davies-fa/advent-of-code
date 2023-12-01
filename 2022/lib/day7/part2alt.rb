require 'csv'
require 'pp'
require 'ostruct'
require 'tree'

module Day7
  class Part2Alt
    def run(input_file)
      lines = File.readlines(input_file).each
      tree = build_tree(lines)

      tree.print_tree

      calculate_sizes!(tree)

      total_space = 70000000
      space_required = 30000000
      space_free = total_space - tree.content
      space_to_find = space_required - space_free

      dirs = tree.select { |n| !n.is_leaf? }
      suitable_dirs = dirs.select { |d| d.content > space_to_find }
      puts suitable_dirs.sort_by(&:content).first

      nil
    end

    def build_tree(lines)
      root_node = Tree::TreeNode.new("/", nil)
      current_node = root_node

      loop do
        line = lines.next
        _, cmd, arg = line.split
        if cmd == "cd"
          if arg == ".."
            current_node = current_node.parent
          else
            existing_node = current_node.children.find { |node| node.name == arg }
            current_node = existing_node || current_node.Tree::TreeNode.new(arg, nil)
          end
        elsif cmd == "ls"
          while(true) do
            line = lines.next
            detail, file = line.split
            size = detail == "dir" ? nil : detail.to_i
            current_node.add(Tree::TreeNode.new(file, size))
            break if lines.peek =~ /\$/
          end
        end
      end

      root_node
    end

    def calculate_sizes!(tree)
      return tree.content if tree.content
      tree.content = tree.children.map { |child| calculate_sizes!(child) }.sum
    end
  end
end
