extends Node2D

var CardBack = preload("res://Universal UI/Card/CardBack.png")
var FieldCard = preload("res://Universal UI/Card/FieldCard.png")

var card_distance = 200  # The distance between cards
var card_vertical_distance = 50  # The distance between rows
var fade_out_ratio = 0.25  # How much the opacity decreases for each row
var max_rows_displayed = 4  # Maximum number of rows to be displayed
var config = []  # This will hold the entire configuration
var queue = []  # This will hold the next rows to be displayed

func _ready():
	config = load_config("res://6RationalGrass/.cardConfig.txt")
	queue = config.slice(0, max_rows_displayed)
	layout_cards()

func load_config(filename):
	var file = File.new()
	if file.file_exists(filename):
		file.open(filename, File.READ)
		var data = []
		while !file.eof_reached():
			var line = file.get_line().split(",")
			data.append(line)
		file.close()
		return data
	else:
		print("Config file not found!")
		return null

func layout_cards():
	if has_node("CardHolder"):
		remove_child(get_node("CardHolder"))  # Remove the previous CardHolder
	
	var card_holder = Node2D.new()  # Create a new CardHolder
	card_holder.name = "CardHolder"
	add_child(card_holder)

	for i in range(len(queue) - 1, -1 ,-1):
		
		var row = queue[i]
		
		for j in range(len(row)):
			var card = Area2D.new()  # Create a new Area2D node
			var sprite = Sprite.new()
			var texture
			
			if row[j] == '00':
				texture = CardBack  # Set the texture to CardBack
			elif row[j] == '01':
				texture = FieldCard  # Set the texture to FieldCard
			
			card_holder.add_child(card)
			
			if texture:
				sprite.texture = texture
				card.add_child(sprite)
				
				var card_size = texture.get_size()
				var x_offset = (get_viewport().size.x - len(row) * card_size.x - (len(row) - 1) * card_distance) / 2 + j * (card_size.x + card_distance)
				var y_offset = get_viewport().size.y / 2 - i * card_vertical_distance

				card.position = Vector2(x_offset, y_offset)  # Adjust the position
				var opacity = max(1 - i * fade_out_ratio, 0)  # Calculate the opacity, but don't let it go below 0
				sprite.modulate = Color(1, 1, 1, opacity)  # Set the opacity

				# Add a collision shape to the card
				var collision_shape = CollisionShape2D.new()
				var rectangle_shape = RectangleShape2D.new()
				rectangle_shape.extents = card_size / 2
				collision_shape.shape = rectangle_shape
				card.add_child(collision_shape)
			
			# Enable input processing after the card has been added to the scene tree
			setup_card(card, i)


func setup_card(card, i):
	card.set_process_input(true)
	card.connect("input_event", self, "_on_Card_pressed", [i])

func _on_Card_pressed(node, event, viewport, row):
	if node.is_inside_tree() and event is InputEventMouseButton and event.pressed:
		queue.pop_front()
		if max_rows_displayed + row < len(config):
			queue.push_back(config[max_rows_displayed + row])
		layout_cards()


