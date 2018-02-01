class App

	_btnMenu = $('.btn-menu')
	_btnTiyan = $('.btn-tiyan')
	_topBar = $('.mhi-topbar')
	_pageBtns = $('.page-btns').find('li')
	_flitems = $('.m-part-2-item')
	_flleft = $('.m-part2-arrowleft')
	_flright = $('.m-part2-arrowright')

	currentFl = 0
	flNum = _flitems.length
	flAnimTime = 500


	#构造
	constructor : ->
		bindEvents()
		setSlider()
		setFl()

	bindEvents = ->
		_btnMenu.on('click',onBtnMenuClick)
		_btnTiyan.on('touchstart',onBtnTiyanTouchStart)
		_btnTiyan.on('touchmove',onBtnTiyanTouchEnd)
		_btnTiyan.on('touchend',onBtnTiyanTouchEnd)
		_pageBtns.on('touchstart',onPageBtnsTouchStart)
		_pageBtns.on('touchmove',onPageBtnsTouchEnd)
		_pageBtns.on('touchend',onPageBtnsTouchEnd)
		_pageBtns.on('click',onPageBtnClicked)
		_flleft.on('click',onFlLeft)
		_flright.on('click',onFlRight)

	setSlider = ->
		$('#mainCarousel').owlCarousel(
			autoPlay : true,
			slideSpeed : 300,
			paginationSpeed : 400,
			singleItem : true,
			stopOnHover : false,
			lazyLoad :true
		)

	setFl = ->
		for i in [0..flNum-1]
			if i != currentFl
				_flitems.eq(i).css('left','150%')

	runFl = (targetFl,direction) ->
		if direction == 'right'
			_flitems.eq(targetFl).css('left','150%')
			_flitems.eq(targetFl).stop().animate(
				{
					left: '50%'
				},
				{
					duration: flAnimTime
				}
			)
			_flitems.eq(currentFl).stop().animate(
				{
					left: '-50%'
				},
				{
					duration: flAnimTime
				}
			)
		else if direction == 'left'
			_flitems.eq(targetFl).css('left','-50%')
			_flitems.eq(targetFl).stop().animate(
				{
					left: '50%'
				},
				{
					duration: flAnimTime
				}
			)
			_flitems.eq(currentFl).stop().animate(
				{
					left: '150%'
				},
				{
					duration: flAnimTime
				}
			)
		currentFl = targetFl

	onFlLeft = (e) ->
		targetFl = currentFl-1
		if currentFl == 0
			targetFl = flNum-1	
		runFl(targetFl,'left')

	onFlRight = (e) ->
		targetFl = currentFl+1
		if currentFl == flNum-1
			targetFl = 0
		runFl(targetFl,'right')

	onBtnMenuClick = (e) ->
		if _topBar.hasClass('expand')
			_topBar.removeClass('expand')
		else
			_topBar.addClass('expand')

	onPageBtnsTouchStart = (e) ->
		id = $(this).index()
		_pageBtns.eq(id).addClass('touched')

	onPageBtnsTouchEnd = (e) ->
		id = $(this).index()
		_pageBtns.eq(id).removeClass('touched')

	onBtnTiyanTouchStart = (e) ->
		_btnTiyan.addClass('touched')

	onBtnTiyanTouchEnd = (e) ->
		_btnTiyan.removeClass('touched')

	onPageBtnClicked = (e) ->
		id = $(this).index()
		if id == 0
			$.scrollTo('.m-part-1',200,{offset:{top:-48,left:0}})
		else if id == 1
			$.scrollTo('.m-part-2',200,{offset:{top:-48,left:0}})
		else if id == 2
			$.scrollTo('.m-part-3',200,{offset:{top:-48,left:0}})
		_topBar.removeClass('expand')

$ ->
	app = new App()