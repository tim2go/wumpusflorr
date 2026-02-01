extends CharacterBody2D

var speed : int = 250
var regular_speed : int = 250
@export var player : Node2D

const max_health : int = 100
var health : float = max_health
var damage : int = 75
var health_recover : int = 20

@onready var hp_bar_bg = %HPBarBg
@onready var hp_bar = %HPBar

var move_angle : float
var bounce_back_time_speed : float = 150
var bounce_back_timer : float = -1
var bounce_back_speed : int = speed * -0.8

func _physics_process(delta: float) -> void:
	if not Global.paused:
		if bounce_back_timer > -0.5:
			bounce_back_timer += bounce_back_time_speed * delta * 2
			speed = lerp(speed, bounce_back_speed, delta * 10)
			print(bounce_back_timer)
		else:
			speed = lerp(speed, regular_speed, delta * 100)
		if bounce_back_timer > bounce_back_time_speed:
			print("b")
			bounce_back_timer = -1
		
		# movement code
		move_angle = position.angle_to_point(player.position)
		if $".".position.distance_to(player.position) > 5:
			velocity = Vector2(speed * cos(move_angle), speed * sin(move_angle))
			move_and_slide()
			
		if health <= 0:
			queue_free()
		health += health_recover * delta
		if health > max_health:
			health = max_health
		hp_bar.size.x = (hp_bar_bg.size.x/max_health) * health

# called when enemy collides with an area2d node
func _on_enemy_area_area_entered(area: Area2D) -> void:
	if area.name == "PelletArea": # if area2d is a pellet
		Global.collided_with_pellet.emit(area) # emit signal to pellet
		health -= area.get_parent().damage
		bounce_back_timer = 0
