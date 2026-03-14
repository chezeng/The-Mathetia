extends Node2D

var status = 0 # 0 = Back; 1 = Front

func _ready():
	$CardDeck/CardBack.connect("gui_input", self, "_on_gui_input")

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$FlipCardToFieldCard.play("flip") # Play the flip animation

