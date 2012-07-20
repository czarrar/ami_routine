module ChildrenHelper
  def children_for_select
    Child.all.collect { |child| [child.name, child.id] }
  end
end
