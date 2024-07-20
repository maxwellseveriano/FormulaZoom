extends Control

@onready var moedas_contador = $container/moedas_container/moedas_contador as Label
@onready var timer_contador = $container/timer_container/timer_contador as Label
@onready var score_contador = $container/score_container/score_contador as Label
@onready var life_contador = $container/life_container/life_contador as Label

# Called when the node enters the scene tree for the first time.
func _ready():
	moedas_contador.text = str("%03d" % Globals.moedas)
	score_contador.text = str("%06d" % Globals.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	moedas_contador.text = str("%03d" % Globals.moedas)
	score_contador.text = str("%06d" % Globals.score)
