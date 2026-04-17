extends Line2D
var start_point
@export var dragging: bool = true
var origin
var target
var color

func _ready() -> void:
	TowerResource.match_color_to_team(self, origin.affiliation)
	match origin.affiliation:
		0: color = Color.CYAN
		1: color = Color.GREEN
		2: color = Color.DARK_RED
		3: color = Color.YELLOW
	material.set_shader_parameter("color", color)

func _process(_delta: float) -> void:
	if dragging:
		set_point_position(0, origin.position)
		set_point_position(1, get_global_mouse_position())
	else:
		set_point_position(0, origin.position) 
		set_point_position(1, target.position)
