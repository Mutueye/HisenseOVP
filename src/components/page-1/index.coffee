class PageA
	currentSlider = -1 #当前轮播页
	sliderTimer = null #轮播计数器
	sliderTime = 5000 #轮播间隔时间
	showTime = 500 #轮播切换淡入淡出时间

	_sliderItems = $('.slider-item')
	_sliderBulletContainer = $('.slider-bullet-container')
	_sliderBullets = null

	sliderWidth = 0 #轮播页宽度
	sliderHeight = 0 #轮播页高度
	sliderNum = _sliderItems.length #轮播页数

	#构造
	constructor : ->
		@initLayout()
		initSliderBullets()
		@startSlider()
		bindEvents()

	#初始化幻灯页面布局
	initLayout : ->
		sliderWidth = _sliderItems.eq(0).width()
		sliderHeight = _sliderItems.eq(0).height()
		setSliderBg($('#sbg_1'),1680,695,sliderWidth,sliderHeight)
		setSliderBg($('#sbg_2'),1680,695,sliderWidth,sliderHeight)
		setSliderBg($('#sbg_3'),1680,695,sliderWidth,sliderHeight)
		setSliderBg($('#sbg_4'),1680,1037,sliderWidth,sliderHeight)

	#初始化翻页点
	initSliderBullets = ->
		for i in [0..sliderNum-1]
			_sliderBulletContainer.append("<li></li>")
		_sliderBullets = _sliderBulletContainer.find('li')

	#设置幻灯背景图片大小和位置
	setSliderBg = (objBg,imgWidth,imgHeight,targetWidth,targetHeight)->
		pct = imgWidth/imgHeight
		if pct >= targetWidth/targetHeight
			objBg.css(
				'width': targetHeight*pct + 'px'
				'height': targetHeight+'px'
				'left': '50%'
				'margin-left': '-'+targetHeight*pct/2+'px'
				'top': '50%'
				'margin-top': '-'+ targetHeight/2+'px'
			)
		else
			objBg.css(
				'width': targetWidth + 'px'
				'height': targetWidth/pct+'px'
				'left':'50%'
				'margin-left':'-'+targetWidth/2+'px'
				'top': '50%'
				'margin-top': '-'+targetWidth*0.5/pct+'px'
			)

	#绑定事件
	bindEvents = ->
		_sliderBullets.on('click',onSliderBulletsClick)

	onSliderBulletsClick = (e) ->
		clickId = $(this).index()
		if currentSlider != clickId
			changeSlider(clickId)
			clearTimeout(sliderTimer)
			sliderTimer = setTimeout(nextSlider,sliderTime)

	#幻灯片播放控制
	startSlider : ->
		if currentSlider != 0
			changeSlider(0)
			clearTimeout(sliderTimer)
			sliderTimer = setTimeout(nextSlider,sliderTime)

	#下翻一页
	nextSlider = ->
		if currentSlider == sliderNum-1
			changeSlider(0)
		else
			changeSlider(currentSlider+1)
		clearTimeout(sliderTimer)
		sliderTimer = setTimeout(nextSlider,sliderTime)

	#换页
	changeSlider = (sNum) ->
		if currentSlider != sNum
			_sliderItems.eq(currentSlider).removeClass('instage')
			_sliderItems.eq(currentSlider).addClass('outstage')
			_sliderItems.eq(currentSlider).stop().animate(
				{
					opacity:0
				},
				{
					duration: 500
				}
			)
			_sliderItems.eq(sNum).addClass('instage')
			_sliderItems.eq(sNum).removeClass('outstage')
			_sliderItems.eq(sNum).stop().animate(
				{
					opacity:1
				},
				{
					duration: 500
				}
			)
			_sliderBullets.eq(currentSlider).removeClass('active')
			_sliderBullets.eq(sNum).addClass('active')
			currentSlider = sNum

module.exports = PageA
