extends Node

# Room state

signal player_entered_room()
signal player_beat_room()
signal player_entered_door(biome : GenerationConditions.BIOMS)

# UI
signal ui_initial_set_inventory_slots_parent(type : ItemKey.ITEM_TYPE, parent : Control)

signal ui_open_inventory()
signal ui_close_inventory()

signal ui_start_dragging_slot(dragged_slot : SlotUI)
signal ui_stop_dragging_slot()

signal ui_update_inventory(items : Dictionary)
signal ui_update_inventory_slots_content(items : Dictionary)
signal ui_update_equiped(equiped : Dictionary)

# Inventory
signal inventory_swap_inventory_slots(type : ItemKey.ITEM_TYPE, slot1_index : int, slot2_index : int)
signal inventory_swap_equipment_slots(type : ItemKey.ITEM_TYPE, slot1_index : int, slot2_index : int)
signal inventory_equip_in_slot(item : ItemKey, slot_index : int)
signal inventory_try_to_equip_in_any_slot(item : ItemKey)
signal inventory_unequip_slot(type : ItemKey.ITEM_TYPE, slot_index : int)
signal inventory_add_item(item_key : ItemKey, amount : int)
signal inventory_remove_item(item_key : ItemKey, amount : int)



# Crafting
signal crafting_update_recipe_showing(recipe : Recipe)
signal crafting_mouse_entered_crafting_slot(slot : CraftingSlotUI)
signal crafting_mouse_exited_crafting_slot(slot : CraftingSlotUI)
signal crafting_select_crafting_slot(slot : CraftingSlotUI)
signal crafting_craft_item(recipe : Recipe)

# Merchant
signal merchant_initialized(merchant_resource : MerchantResource)
signal merchant_player_entered_detector()
signal merchant_player_exited_detector()
