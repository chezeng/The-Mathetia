extends Node

var dialogue_file = "res://dialogue.txt"
var dialogue_lines = []
var current_line = 0

var character_name_node = null
var dialogue_node = null
var character_sprite_node = null

# 用于储存角色和对应立绘的字典，需要自行填写
var character_sprites = {
	"Bob": preload("res://bob.tscn"),
	"Alice": preload("res://alice.tscn"),
}

func _ready():
	character_name_node = get_node("你的角色名标签路径")
	dialogue_node = get_node("你的对话框路径")
	character_sprite_node = get_node("你的角色立绘路径")

	_load_dialogue()

# 从文件中加载对话
func _load_dialogue():
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, File.READ)
		while !file.eof_reached():
			var line = file.get_line()
			dialogue_lines.append(line)
		file.close()

# 展示下一句对话
func display_next_line():
	if current_line < dialogue_lines.size():
		var line = dialogue_lines[current_line]
		var parts = line.split(": ")
		if parts.size() == 2:
			if parts[0] == "CHARACTER":
				character_name_node.text = parts[1]
				if parts[1] in character_sprites:
					character_sprite_node.set_texture(character_sprites[parts[1]])
			elif parts[0] == "DIALOGUE":
				dialogue_node.text = parts[1]
			current_line += 1
