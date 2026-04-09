extends Resource
class_name TowerResource

@export var type: TowerType
@export var location: Vector2
@export var level: int
@export var occupants: int
@export var affiliation: Players

enum TowerType{
	OFFENSIVE,
	DEFENSIVE,
	ECONOMY,
}

enum Players {
	BLUE, # Player
	GREEN,
	RED,
	YELLOW,
}

static func match_team(team: String, tower: TowerResource) -> TowerResource:
	match team: 
		"Blue": tower.affiliation = TowerResource.Players.BLUE 
		"Green": tower.affiliation = TowerResource.Players.GREEN
		"Red": tower.affiliation = TowerResource.Players.RED
		"Yellow": tower.affiliation = TowerResource.Players.YELLOW
	return tower

static func match_color_to_team(sprite, aff: TowerResource.Players):
	match aff:
		0: sprite.set_self_modulate(Color.DARK_BLUE)
		1: sprite.set_self_modulate(Color.GREEN)
		2: sprite.set_self_modulate(Color.DARK_RED)
		3: sprite.set_self_modulate(Color.YELLOW)

static func match_type(tower_type: String, tower: TowerResource) -> TowerResource:
	match tower_type:
		"Offensive": tower.type = TowerResource.TowerType.OFFENSIVE
		"Defensive": tower.type = TowerResource.TowerType.DEFENSIVE
		"Economy": tower.type = TowerResource.TowerType.ECONOMY
		
	return tower
	
