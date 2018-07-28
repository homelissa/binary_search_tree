# There are many ways to implement these methods, feel free to add arguments
# to methods as you see fit, or to create helper methods.

class BinarySearchTree
  attr_reader :root
  def initialize
    @root = nil
    @count = 0
  end

  def insert(value)
    @root.nil? ? @root = BSTNode.new(value) : rec_insert(@root, value)
    @count += 1
  end

  def find(value, tree_node = @root)
    return nil if tree_node.nil?
    if value == tree_node.value
      return tree_node
    elsif value <= tree_node.value
      find(value, tree_node.left)
    elsif value > tree_node.value
      find(value, tree_node.right)
    end
  end

  def delete(value)
    return @root = nil if @root.value == value

    parent = get_parent(value, @root)

    if parent.left.value == value && no_children?(parent.left)
      parent.left = nil
    elsif parent.right.value == value && no_children?(parent.right)
      parent.right = nil
    end

    if parent.right && parent.right.left.nil? && parent.right.value == value
      parent.right = parent.right.right
    elsif parent.left && parent.left.left.nil? && parent.left.value == value
      parent.left = parent.left.right
    end

    if parent.left && parent.left.value == value
      max = maximum(parent.left.left) # 2
      max_parent = get_parent(max.value)
      remove_node = parent.left #3
      parent.left = max # 3 is gone, replaced with 2
      max_parent.right = max.left

      max.left = remove_node.left # 2 points to 1
      max.right = remove_node.right  # 2 points to 4
    end

    @count -= 1
  end

  # helper method for #delete:
  def maximum(tree_node = @root)
    max = tree_node
    until max.right.nil?
      max = max.right
    end
    max
  end

  def depth(tree_node = @root)
    Math.log2(@count).ceil
  end


  def is_balanced?(tree_node = @root)
    max_depth(tree_node) == depth
  end

  def in_order_traversal(tree_node = @root, arr = [])
    return [] unless tree_node
    left = in_order_traversal(tree_node.left)
    right = in_order_traversal(tree_node.right)
    left + [ tree_node.value ] + right

  end


  private
  def rec_insert(node, value)
    if node.nil?
      node = BSTNode.new(value)
    elsif (value <= node.value)
      node.left = rec_insert(node.left, value)
    else
      node.right = rec_insert(node.right, value)
    end
    return node
  end

  def get_parent(value, node=@root)
    return nil if node.nil?
    if node.left.value == value || node.right.value == value
      return node
    elsif value <= node.value
      get_parent(value, node.left)
    elsif value > node.value
      get_parent(value, node.right)
    else
      return nil
    end
  end

  def no_children?(node)
    node.left.nil? && node.right.nil?
  end

  def max_depth(node)
    return 0 if !node
    left = max_depth(node.left)
    right = max_depth(node.right)

    left > right ? left + 1 : right + 1
  end
end
