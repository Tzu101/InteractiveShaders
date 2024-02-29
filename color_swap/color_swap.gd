extends Node2D


func _on_color_picker_color_changed(color: Color):
	$Greenscreen.material.set_shader_parameter("replacement_color", color)
