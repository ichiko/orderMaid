# 21_gameview_order.coffee

# 注文はまとめて、
# 各メニューについて個数を指定して、一括で行なう
class OrderPanelScene extends BasePanelScene
	constructor: (stageInfo) ->
		super
		@game = OrderMaid.game
		@stageInfo = stageInfo

		@exitSequence = false

		@createScene()
		@batchEnd()

	createScene: ->
		@orderCountLabels = []
		menuList = @stageInfo.get('menu')

		@cursor = new Cursor(menuList.length)

		@drawBackPanel()
		@drawMenu(menuList)
		@drawStartCook()
		@addChild @cursor

	# シーンで処理が完結するときtrueを返す
	onenterkeySpace: ->
		if @cursor.cursor_y == @cursor.max_y
			@exitSequence = true
			i = 0
			len = @orderCountLabels.length
			menuList = @stageInfo.get('menu')
			@cookingList = []
			while i < len
				count = parseInt(@orderCountLabels[i].text, 10)
				menu = menuList.models[i]
				@cookingList.push({id: menu.get('id'), count: count })
				i++
			console.log @cookingList
			return false
		return true

	onenterkeyCursor: (dict) ->
		if @exitSequence
			return
		switch dict
			when GameView.Direction.Left
				i = @cursor.cursor_y
				if i < @orderCountLabels.length
					count = parseInt(@orderCountLabels[i].text, 10)
					if count > 0
						@orderCountLabels[i].text = count - 1
			when GameView.Direction.Right
				i = @cursor.cursor_y
				if i < @orderCountLabels.length
					count = parseInt(@orderCountLabels[i].text, 10)
					if count < 9
						@orderCountLabels[i].text = count + 1
			when GameView.Direction.Up
				@cursor.up()
			when GameView.Direction.Down
				@cursor.down()

	drawMenu: (menuList) ->
		@menuCount = 0
		menuList.each (dish) =>
			@drawMenuLabel dish

	drawMenuLabel: (dish) ->
		label = @createOrderedLabel(210, 105, 38, @menuCount)
		label.text = dish.get('name')
		@addChild label
		@createOrderCount @menuCount
		@menuCount++

	createOrderCount: (count) ->
		label = @createOrderedLabel(160, 103, 38, count)
		label.text = 0
		@addChild label
		@orderCountLabels.push(label)

	drawStartCook: ->
		btn_width = 120
		btn_height = 38
		button = new Sprite(btn_width, btn_height)
		button.backgroundColor = '#000000'
		button.x = (GameView.settings.ScreenWidth - btn_width) / 2
		marginBtm = (GameView.settings.ScreenHeight - GameView.settings.OrderPanel.Height) / 2
		button.y = GameView.settings.ScreenHeight - marginBtm - 10 - btn_height
		@addChild button

		border_width = 3
		button_f = new Sprite(btn_width - border_width * 2, btn_height - border_width * 2)
		button_f.backgroundColor = '#a68757'
		button_f.x = button.x + border_width
		button_f.y = button.y + border_width
		@addChild button_f

		btnLabel = new Label()
		btnLabel.text = "決定"
		btnLabel.font = GameView.settings.OrderPanel.Font
		btnLabel.x = button.x + 32
		btnLabel.y = button.y + 3
		@addChild btnLabel

class Cursor extends BaseCursor
	constructor: (menuCount)->
		super(menuCount)
		@update

	update: ->
		if @cursor_y == @max_y 
			@x = 220
			@y = 105 + 38 * 6 + 24
		else
			@x = 120
			@y = 105 + 38 * @cursor_y
