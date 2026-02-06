extends Line2D
@export var max_points: int = 10
@export var point_spacing: float = 2.0

@onready var pellet_node = get_parent()
@onready var player_node = pellet_node.get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear_points()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pellet_node == null or player_node == null:
		return

	# Keep the trail offset by the player, but record only pellet motion
	# in the player's local space.
	global_position = player_node.global_position
	var true_position = pellet_node.position/2
	
	if get_point_count() == 0:
		add_point(true_position)
		return
	var last_point = get_point_position(get_point_count()-1)
	
	if true_position.distance_to(last_point) >= point_spacing:
		add_point(true_position)
		if get_point_count() > max_points:
			remove_point(0) #get out
