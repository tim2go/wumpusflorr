extends Node
class_name RoomNode

''' graph = {
    1: [2, 5, 8],
    2: [1, 3, 10],
    3: [2, 4, 12],
    4: [3, 5, 14],
    5: [1, 4, 6],
    6: [5, 7, 15],
    7: [6, 8, 17],
    8: [1, 7, 11],
    9: [12, 10, 19],
    10: [2, 9, 11],
    11: [8, 10, 20],
    12: [3, 9, 13],
    13: [12, 14, 18],
    14: [4, 13, 15],
    15: [6, 14, 16],
    16: [15, 17, 18],
    17: [7, 16, 20],
    18: [13, 16, 19],
    19: [9, 18, 20],
    20: [11, 17, 19]
}
'''

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
