extends CharacterBody2D

@export var speed : int = 250
@export var player : Node2D

func _physics_process(delta: float) -> void:
	
	# movement code
	var move_angle = $".".position.angle_to_point(player.position)
	if $".".position.distance_to(player.position) > 5:
		velocity = Vector2(speed * cos(move_angle), speed * sin(move_angle))
		move_and_slide()

# called when enemy collides with an area2d node
func _on_enemy_area_area_entered(area: Area2D) -> void:
	if area.name == "PelletArea": # if area2d is a pellet
		Global.collided_with_pellet.emit(area) # emit signal to pellet
		queue_free() # delete enemy
