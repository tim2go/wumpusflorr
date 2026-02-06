extends Node
class_name RoomNode

var neighbors: Array[RoomNode]
var length = 0

func add_neighbor(node: RoomNode):
	if node_is_pedophile() or node.node_is_pedophile():
		return false
	node.add_neighbor(self)
	length += 1
	return true
func get_neighbors():
	if not node_is_perfect():
		return false
	return neighbors
	

# I CAN'T WAIT FOR IT TO TURN 18!!!!! 🤤🤤
func node_is_perfect():
	return count_neighbors() == 3
func node_is_pedophile():
	return count_neighbors() >= 3
func count_neighbors():
	return length
