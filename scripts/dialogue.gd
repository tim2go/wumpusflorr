class_name Dialogue
extends Node

var text: String
var texture: Texture2D

func _init(t: String, te: Texture2D = null):
	text = t
	texture = te
