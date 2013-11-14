# helper.coffee
# require model.coffee

class MenuHelper
	init: (menu) ->
		@dishList = menu

	getDishName: (dish_id) ->
		if @dishList?
			@dishList.each (dish) ->
				id = dish.get('id')
				if id == dish_id
					return dish.get('name')
		return ''