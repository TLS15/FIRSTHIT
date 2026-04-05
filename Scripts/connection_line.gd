extends Line2D
var start_point
@export var dragging = true
var origin
var target


# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	#set_point_position(0, get_global_mouse_position())
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		set_point_position(0, origin.position)
		set_point_position(1, get_global_mouse_position())
	else:
		set_point_position(0, origin.position) # might need to make global
		set_point_position(1, target.position)
