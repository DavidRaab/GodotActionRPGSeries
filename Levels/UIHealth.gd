extends Control

@onready var player = %Player
@onready var full   = $Full
@onready var empty  = $Empty

func update_health(value, maximum):
    empty.size.x = maximum * 15;
    full.size.x  = value * 15;

# Called when the node enters the scene tree for the first time.
func _ready():
    # Initialize Health Bar
    var health : HealthComponent = player.get_node("HealthComponent")
    update_health(health.get_health(), health.get_max_health())
    
    # update Health UI on Life Change
    health.health_changed.connect(func(value,minimum,maximum): update_health(value,maximum))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
