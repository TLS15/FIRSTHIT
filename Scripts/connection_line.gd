extends Line2D
var start_point
@export var dragging = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_point = get_global_mouse_position()
	set_point_position(0, get_local_mouse_position())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		set_point_position(1, get_global_mouse_position())
