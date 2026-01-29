extends Node

#variables here can be accessed by any script

signal collided_with_pellet(collided_area : Area2D) # signal to comminicate between pellets and enemies
var pellet_inventory : Array # array to keep track of pellets, used in pellets and player
