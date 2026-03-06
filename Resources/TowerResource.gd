extends Resource
class_name TowerResource
enum TowerType{
	DEFENSIVE,
	OFFENSIVE,
	ECONOMY,
}

enum Players {
	BLUE, # Player
	GREEN,
	RED,
	YELLOW,
}
@export var type: TowerType
@export var location: Vector2
@export var level: int
@export var occupants: int
@export var affiliation: Players
