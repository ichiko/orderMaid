# orderMaid.coffee

class OrderMaidGame
	constructor: ->
		console.log "window.onload"
		generator = new StageGenerator()
		stageInfo = generator.generateStageInfo()
		new StatusView({ model: stageInfo })
		new GameScreenView({ model: stageInfo })

# generator
class StageGenerator
	generateStageInfo: ->
		stage = new StageInfo({ title: '初出勤' })
		@setMenuList(stage)
		@setOrderList(stage)
		return stage

	setMenuList: (stage) ->
		menu = stage.get('menu')
		menu.add({ id: 1, name: 'オムライス' })
		menu.add(new Dish({ id: 2, name: 'ハンバーグ' }))
		menu.add(new Dish({ id: 3, name: 'ハッシュドビーフ' }))
		menu.add(new Dish({ id: 4, name: 'すし' }))
		menu.add(new Dish({ id: 5, name: 'プリン ア・ラ・モード' }))
		menu.add(new Dish({ id: 6, name: 'ミートソース スパゲティ' }))

	setOrderList: (stage) ->
		orders = stage.get('customers')
		orders.add(new CustomerOrder({ cell_x: 16, cell_y: 4, waitingMsg: 'このときを待っていた!', dishId: 1, score: 100, charIconNo: 1}))
		orders.add(new CustomerOrder({ cell_x: 3, cell_y: 10, waitingMsg: 'まだかなぁ。。。', dishId: 4, score: 200, charIconNo: 2}))

window.OrderMaidGame = OrderMaidGame