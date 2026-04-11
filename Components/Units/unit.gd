extends Area2D

@export var health: int = 30
@export var attack: int = 30
@export var affiliation: TowerResource.Players

var origin_tower
var target_tower

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TowerResource.match_color_to_team($Sprite2D, affiliation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var speed: float = 50.0 

	global_position = global_position.move_toward(target_tower.position, speed * delta)
	if global_position == target_tower.position:
		target_tower.interact(self)

func assign_resource(resource: UnitResource):
	health = resource.health
	attack = resource.attack
	$Sprite2D.texture = resource.sprite
	
func _on_area_entered(area: Area2D) -> void:
	if area.affiliation != affiliation and area.target_tower == origin_tower and area.origin_tower == target_tower:
		area.interact(attack, affiliation)

func reinforce(reinforcment_points: int):
	health += reinforcment_points

func damage(att: int):
	health -= att
	if health < 1:
		queue_free()
	
func interact(att, team):
	if team == affiliation:
		if target_tower.occupants >= 50:
			origin_tower = target_tower
			target_tower = origin_tower.connections[randi() % origin_tower.connections.size]
		else:
			reinforce(att)
	else:
		damage(att)
