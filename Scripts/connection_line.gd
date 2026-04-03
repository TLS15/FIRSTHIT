extends Line2D
var start_point
@export var dragging = true
@export var id_origin: int
@export var id_target: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	#set_point_position(0, get_global_mouse_position())
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		set_point_position(1, get_global_mouse_position())
