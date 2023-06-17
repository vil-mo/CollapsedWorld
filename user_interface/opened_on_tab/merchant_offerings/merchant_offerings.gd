extends OpenedOnTab

func _ready() -> void:
	super()
	EventBus.merchant_initialized.connect(initialize_menus)
	EventBus.merchant_player_entered_detector.connect(on_player_entered_detector)
	EventBus.merchant_player_exited_detector.connect(on_player_exited_detector)

func initialize_menus(merchant_resource : MerchantResource):
	can_be_opened = false
	
	for child in panel.get_children():
		panel.remove_child(child)
		child.queue_free()
	for i in merchant_resource.merchant_menus.size():
		var menu = merchant_resource.merchant_menus[i].instantiate()
		panel.add_child(menu, true)
		if menu.has_meta("tab_title"):
			panel.set_tab_title(i, menu.get_meta("tab_title"))

func on_player_entered_detector():
	can_be_opened = true

func on_player_exited_detector():
	can_be_opened = false
