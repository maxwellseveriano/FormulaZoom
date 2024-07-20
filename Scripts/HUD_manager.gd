extends Control

@onready var moedas_contador = $container/moedas_container/moedas_contador as Label
@onready var timer_contador = $container/timer_container/timer_contador as Label
@onready var score_contador = $container/score_container/score_contador as Label
@onready var life_contador = $container/life_container/life_contador as Label
@onready var clock_timer = $clock_timer as Timer

var minutes := 0
var seconds := 0
@export_range(0, 5) var default_minutes := 1
@export_range(0, 59) var default_seconds := 0

signal time_is_up()

# Called when the node enters the scene tree for the first time.
func _ready():
	moedas_contador.text = str("%03d" % Globals.moedas)
	score_contador.text = str("%05d" % Globals.score)
	life_contador.text = str("%02d" % Globals.player_life)
	timer_contador.text = str("%02d" % default_minutes) + ":" + str("%02d" % default_seconds)
	reset_clock_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	moedas_contador.text = str("%03d" % Globals.moedas)
	score_contador.text = str("%05d" % Globals.score)
	life_contador.text = str("%02d" % Globals.player_life)
	
	if minutes == 0 and seconds == 0:
		emit_signal("time_is_up")


func _on_clock_timer_timeout():
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds = 60
	seconds -= 1
	
	timer_contador.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)
	
func reset_clock_timer():
	minutes = default_minutes
	seconds = default_seconds
