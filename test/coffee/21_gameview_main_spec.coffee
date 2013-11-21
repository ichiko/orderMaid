# dom_view_screen.coffee
# target dom_view_screen.coffee

describe 'OrderMaidGameView', ->

	describe 'checkInputDelay', ->
		game = null
		beforeEach ->
			game = new OrderMaidGameView()

		it 'when initialized, tick is reset', ->
			expect(game.prevTick).toEqual(0)

		it 'return false when not timeout', ->
			spyOn(game, 'getCurrentMilli').andReturn(10)
			expect(game.checkInputDelay()).toBe(false)

		it 'return true when time', ->
			spyOn(game, 'getCurrentMilli').andReturn(101)
			expect(game.checkInputDelay()).toBe(true)

	describe '状態遷移系', ->
		game = null

		beforeEach ->
			stageInfo = new StageInfo()
			customers = stageInfo.get('customers')
			customers.add(new CustomerOrder())
			customers.add(new CustomerOrder())
			customers.add(new CustomerOrder())
			game = new OrderMaidGameView(stageInfo)

			spyOn(game, 'popScene').andCallFake ->
				return 0
			spyOn(game, 'pushFloorScene').andCallFake ->
				return 1
			spyOn(game, 'pushOrderScene').andCallFake ->
				return 2
			spyOn(game, 'pushChoiseScene').andCallFake ->
				return 3
			spyOn(game, 'pushResultScene').andCallFake ->
				return 4
			spyOn(game, 'sceneIsReady').andCallFake ->
				return true
			spyOn(game, 'floorShowOrders').andCallFake ->
				return true
			spyOn(game, 'floorCloseOrders').andCallFake ->
				return true

		describe '初期化直後', ->
			it 'status is loading', ->
				expect(game.status()).toEqual(StageInfo.STATE_LOADING)
			it 'disable key input', ->
				expect(game.enableSpaceKeyInput()).toBe(false)
			it 'disable cursor input', ->
				expect(game.enableCursorKeyInput()).toBe(false)

		describe 'ステージ読み込み後', ->
			beforeEach ->
				game.loadStage()

			it 'status is ready', ->
				expect(game.status()).toEqual(StageInfo.STATE_MAIN_READY)
			it 'enable key input', ->
				expect(game.enableSpaceKeyInput()).toBe(true)
			it 'disable cursor input', ->
				expect(game.enableCursorKeyInput()).toBe(false)
			it 'フロアSceneがロードされる', ->
				expect(game.pushFloorScene).toHaveBeenCalled()

		describe 'お客の注文を表示したとき', ->
			beforeEach ->
				game.startTakeOrder()

			it 'status is take order', ->
				expect(game.status()).toEqual(StageInfo.STATE_MAIN_TAKE_ORDER)
			it 'enable key input', ->
				expect(game.enableSpaceKeyInput()).toBe(true)
			it 'disable cursor input', ->
				expect(game.enableCursorKeyInput()).toBe(false)
			it 'Sceneは変更されない', ->
				expect(game.pushFloorScene).not.toHaveBeenCalled()
				expect(game.pushOrderScene).not.toHaveBeenCalled()
				expect(game.pushChoiseScene).not.toHaveBeenCalled()
				expect(game.pushResultScene).not.toHaveBeenCalled()
				expect(game.popScene).not.toHaveBeenCalled()

		describe 'お客の注文を閉じたとき', ->
			beforeEach ->
				game.didTakeOrder()

			it 'status is going to chef', ->
				expect(game.status()).toEqual(StageInfo.STATE_MAIN_PRE_ORDER_TO_CHEF)
			it 'enable key input', ->
				expect(game.enableSpaceKeyInput()).toBe(true)
			it 'enable cursor input', ->
				expect(game.enableCursorKeyInput()).toBe(true)
			it 'Sceneは変更されない', ->
				expect(game.pushFloorScene).not.toHaveBeenCalled()
				expect(game.pushOrderScene).not.toHaveBeenCalled()
				expect(game.pushChoiseScene).not.toHaveBeenCalled()
				expect(game.pushResultScene).not.toHaveBeenCalled()
				expect(game.popScene).not.toHaveBeenCalled()

		describe 'シェフに話かけたとき', ->
			beforeEach ->
				game.orderToChef()

			it 'status is order to chef', ->
				expect(game.status()).toEqual(StageInfo.STATE_MAIN_ORDER_TO_CHEF)
			it 'enable key input', ->
				expect(game.enableSpaceKeyInput()).toBe(true)
			it 'enable cursor input', ->
				expect(game.enableCursorKeyInput()).toBe(true)
			it '注文画面を表示する', ->
				expect(game.pushOrderScene).toHaveBeenCalled()

		describe 'シェフに注文完了したとき', ->
			beforeEach ->
				game.didOrderToChef()

			it 'status is cooking', ->
				expect(game.status()).toEqual(StageInfo.STATE_MAIN_COOKING)
			it 'disable key input', ->
				expect(game.enableSpaceKeyInput()).toBe(false)
			it 'disable cursor input', ->
				expect(game.enableCursorKeyInput()).toBe(false)
			it '注文画面を閉じる', ->
				expect(game.popScene).toHaveBeenCalled()

		describe '調理が完了したとき', ->
			beforeEach ->
				game.didCook()

			it 'status is dish ready', ->
				expect(game.status()).toEqual(StageInfo.STATE_MAIN_DISH_READY)
			it 'enable key input', ->
				expect(game.enableSpaceKeyInput()).toBe(true)
			it 'enable cursor input', ->
				expect(game.enableCursorKeyInput()).toBe(true)

		describe '調理完了後、シェフにはなしかけたとき', ->
			beforeEach ->
				game.takeFromChef()

			it 'status is take from chef', ->
				expect(game.status()).toEqual(StageInfo.STATE_MAIN_TAKE_DISH_FROM_CHEF)
			it 'enable key input', ->
				expect(game.enableSpaceKeyInput()).toBe(true)
			it 'disable cursor input', ->
				expect(game.enableCursorKeyInput()).toBe(false)

		describe '調理品を受け取ったとき', ->
			beforeEach ->
				game.startFloorServe()

			it 'status is delivering', ->
				expect(game.status()).toEqual(StageInfo.STATE_MAIN_DELIVER_DISH)
			it 'enable key input', ->
				expect(game.enableSpaceKeyInput()).toBe(true)
			it 'enable cursor input', ->
				expect(game.enableCursorKeyInput()).toBe(true)
			it 'Sceneは変更されない', ->
				expect(game.pushFloorScene).not.toHaveBeenCalled()
				expect(game.pushOrderScene).not.toHaveBeenCalled()
				expect(game.pushChoiseScene).not.toHaveBeenCalled()
				expect(game.pushResultScene).not.toHaveBeenCalled()
				expect(game.popScene).not.toHaveBeenCalled()

		describe '料理を持って、お客にはなしかけたとき', ->
			beforeEach ->
				game.startServeDish()

			it 'status is serve', ->
				expect(game.status()).toEqual(StageInfo.STATE_MAIN_SERVE_DISH)
			it 'enable key input', ->
				expect(game.enableSpaceKeyInput()).toBe(true)
			it 'disable cursor input', ->
				expect(game.enableCursorKeyInput()).toBe(false)
			it 'Sceneは変更されない', ->
				expect(game.pushFloorScene).not.toHaveBeenCalled()
				expect(game.pushOrderScene).not.toHaveBeenCalled()
				expect(game.pushChoiseScene).not.toHaveBeenCalled()
				expect(game.pushResultScene).not.toHaveBeenCalled()
				expect(game.popScene).not.toHaveBeenCalled()

		describe 'お客のせりふを閉じたとき', ->
			beforeEach ->
				game.showChoisePanel()

			it 'status is select dish', ->
				expect(game.status()).toEqual(StageInfo.STATE_MAIN_SELECT_DISH)
			it 'disable key input', ->
				expect(game.enableSpaceKeyInput()).toBe(true)
			it 'disable cursor input', ->
				expect(game.enableCursorKeyInput()).toBe(true)
			it '選択画面を表示する', ->
				expect(game.pushChoiseScene).toHaveBeenCalled()

		describe '品を選択したとき', ->
			beforeEach ->
				game.didSelectServeDish()

			it 'status is check dish', ->
				expect(game.status()).toEqual(StageInfo.STATE_MAIN_CHECK_DISH)
			it 'disable key input', ->
				expect(game.enableSpaceKeyInput()).toBe(true)
			it 'disable cursor input', ->
				expect(game.enableCursorKeyInput()).toBe(false)
			it '選択画面を閉じる', ->
				expect(game.popScene).toHaveBeenCalled()

		describe 'お客の結果を閉じたとき(未回答あり)', ->

			beforeEach ->
				game.stageInfo.get('customers').models[0].set('isDelivered', true)
				game.didServeDish()

			it 'status is delivering', ->
				expect(game.status()).toEqual(StageInfo.STATE_MAIN_DELIVER_DISH)
			it 'enable key input', ->
				expect(game.enableSpaceKeyInput()).toBe(true)
			it 'enable cursor input', ->
				expect(game.enableCursorKeyInput()).toBe(true)
			it 'Sceneは変更されない', ->
				expect(game.pushFloorScene).not.toHaveBeenCalled()
				expect(game.pushOrderScene).not.toHaveBeenCalled()
				expect(game.pushChoiseScene).not.toHaveBeenCalled()
				expect(game.pushResultScene).not.toHaveBeenCalled()
				expect(game.popScene).not.toHaveBeenCalled()

		describe 'お客の結果を閉じたとき(全問回答)', ->

			beforeEach ->
				game.stageInfo.get('customers').each (cstm) ->
					cstm.set('isDelivered', true)
				game.didServeDish()

			it 'status is all done', ->
				expect(game.status()).toEqual(StageInfo.STATE_MAIN_ALL_DELIVERED)
			it 'disable key input', ->
				expect(game.enableSpaceKeyInput()).toBe(true)
			it 'disable cursor input', ->
				expect(game.enableCursorKeyInput()).toBe(false)
			it '結果画面を表示する', ->
				expect(game.pushResultScene).toHaveBeenCalled()