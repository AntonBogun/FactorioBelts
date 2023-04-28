extends GraphNode

var type
var belt_display=preload("res://belt_display.tscn")
var interactive_belt_display=preload("res://interactive_belt_display.tscn")

signal delete


#type expected to be a string
#recognized: Input,Splitter,Underground,OneSide,Output
func init(_type):
	type=_type
	title=type
	if type=="Input":
		# $div/Belts/ShowMore.hide()
		$div/Belts/ThroughputLabel.text="Max Output:"
		$div/Belts/DetailedInfo/InputLabel.hide()
		$div/Belts/DetailedInfo/InputBeltDisplay.hide()
		
		set_slot(0,0,0,Color.GREEN,1,0,Color.BLUE)
		
		var _i=interactive_belt_display.instantiate()
		$div/Belts/ThroughputBeltDisplay.add_child(_i)
		
		var _o=belt_display.instantiate()
		_o.init("True Output",[0,0],"/m")

	elif type=="Splitter":
		set_slot(0,1,0,Color.YELLOW,1,0,Color.GOLD)
		set_slot(1,1,0,Color.ORANGE,1,0,Color.GOLD)
		
		var _t1=belt_display.instantiate()
		_t1.init("Output Left",[0,0],"/m")
		var _t2=belt_display.instantiate()
		_t2.init("Output Right",[0,0],"/m")
		$div/Belts/ThroughputBeltDisplay.add_child(_t1)
		$div/Belts/ThroughputBeltDisplay.add_child(_t2)
		
		var _i1=belt_display.instantiate()
		_i1.init("Input Left",[0,0],"/m")
		var _i2=belt_display.instantiate()
		_i2.init("Input Right",[0,0],"/m")
		$div/Belts/DetailedInfo/InputBeltDisplay.add_child(_i1)
		$div/Belts/DetailedInfo/InputBeltDisplay.add_child(_i2)

		var _o1=belt_display.instantiate()
		_o1.init("Max Output Left",[0,0],"/m")
		var _o2=belt_display.instantiate()
		_o2.init("Max Output Right",[0,0],"/m")
		$div/Belts/DetailedInfo/OutputBeltDisplay.add_child(_o1)
		$div/Belts/DetailedInfo/OutputBeltDisplay.add_child(_o2)
	
	elif type=="Underground" or type=="OneSide":
		set_slot(0,1,0,Color.YELLOW,0,0,Color.BLUE)
		set_slot(1,1,0,Color.PURPLE,1,0,Color.GOLD)
		set_slot(2,1,0,Color.ORANGE,0,0,Color.BLUE)
		
		var _t1=belt_display.instantiate()
		_t1.init("Output",[0,0],"/m")
		$div/Belts/ThroughputBeltDisplay.add_child(_t1)
		
		var _i1=belt_display.instantiate()
		_i1.init("Input Left",[0,0],"/m")
		var _i2=belt_display.instantiate()
		_i2.init("Input Middle",[0,0],"/m")
		var _i3=belt_display.instantiate()
		_i3.init("Input Right",[0,0],"/m")
		$div/Belts/DetailedInfo/InputBeltDisplay.add_child(_i1)
		$div/Belts/DetailedInfo/InputBeltDisplay.add_child(_i2)
		$div/Belts/DetailedInfo/InputBeltDisplay.add_child(_i3)

		var _o1=belt_display.instantiate()
		_o1.init("Max Output",[0,0],"/m")
		$div/Belts/DetailedInfo/OutputBeltDisplay.add_child(_o1)
		
	elif type=="Output":
		$div/Belts/ThroughputLabel.text="Desired Output:"
		$div/Belts/ShowMore.hide()
		$div/Belts/DetailedInfo.show()
		$div/Belts/DetailedInfo/OutputLabel.hide()
		$div/Belts/DetailedInfo/OutputBeltDisplay.hide()
		$div/Belt/DetailedInfo/InputLabel.text="Input:"

		
		set_slot(0,1,0,Color.GREEN,0,0,Color.GREEN)
		
		var _i=interactive_belt_display.instantiate()
		$div/Belts/ThroughputBeltDisplay.add_child(_i)
		
		var _o=belt_display.instantiate()
		_o.init("True Input",[0,0],"/m")
		
	else:
		print("Error: unrecognized type in GraphNode.gd")
		return



func connect_to_delete(_callable):
	delete.connect(_callable)

func _on_focus_changed(control:Control):
	if control != null:
		print(control.name, "print at GraphNode.gd")

func _ready():
	get_viewport().gui_focus_changed.connect(_on_focus_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_show_more_toggled(button_pressed):
	if button_pressed:
		$div/Belts/DetailedInfo.show()
		$div/Belts/ShowMore.text="Show Less"
	else:
		$div/Belts/DetailedInfo.hide()
		$div/Belts/ShowMore.text="Show More"


func _on_delete_toggled(button_pressed):
	if button_pressed:
		$div/Delete.text="Are you sure?"
	else:
		delete.emit()



func _on_delete_focus_exited():
	$div/Delete.text="Delete"
	$div/Delete.set_pressed_no_signal(false)
