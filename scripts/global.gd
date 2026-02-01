extends Node

#variables here can be accessed by any script

var paused := false

signal collided_with_pellet(collided_area : Area2D) # signal to comminicate between pellets and enemies
signal display_dialogue(dialogue: Array[Dialogue])
var pellet_inventory : Array # array to keep track of pellets, used in pellets and player
