PageA = require('../../components/page-1/index.coffee')
PageB = require('../../components/page-2/index.coffee')
PageC = require('../../components/page-3/index.coffee')

class App
    hideTopBar = true #翻页后是否隐藏topbar

    currentPage = 0 #当前页码
    currentPos = 0 #当前总容器的位置
    canGoNext = true #判断鼠标滚动是否可翻页
    canGoNextTimer = null #鼠标滚动时间间隔计数器
    canGoNextTime = 1000 #鼠标滚动时间间隔
    pageTime = 1000 #翻页动画时长
    currentIcon = 0 #当前显示内容的顶部右侧图标

    _topBar = $('.hi-top') #顶部栏
    _navBar = $('.hi-nav') #导航栏
    _navBtnContainer = $('.hi-nav-btn-container') #导航按钮容器
    _navBtns = $('.hi-nav-btn') #导航按钮们
    _navTiyanBtn = $('.hi-tiyan-btn') #'体验试用'按钮

    _pageItems = $('.hi-item') #页面们
    _pageContainer = $('.hi-container') #页面容器
    _pager = $('.hi-pager') #分页点容器
    _pagerItems = null #分页点们
    _pagerSelector = $('.hi-pager-selector') #当前分页点

    _topIcons = $('.top-icon.has-text')

    winHeight = 0 #显示区高度
    pageNum = _pageItems.length #页面总数
    pageContainerHeight = 0 #页面容器高度

    navNum = _navBtns.length #导航按钮总数
    navContainerWidth = 0 #导航按钮容器宽度
    navContaienrMright = 0 #导航按钮容器变化后margin-right的值

    inpageScrollSpeed = 100 #页面内部滚动速度

    pageA = new PageA()
    pageB = new PageB()
    pageC = new PageC()

    #构造
    constructor : ->
        initPager()
        initLayout()
        bindEvents()
        window.onload =->
            initLayout()

    #初始化布局
    initLayout = ->
        if window.innerHeight
            winHeight = window.innerHeight
        else if document.body && document.body.clientHeight
            winHeight = document.body.clientHeight
        else
            winHeight = document.documentElement.clientHeight # 修正ie7/ie8获取不到窗口高度
        $('.full-height').css('height',winHeight+'px')

        navContainerWidth = 0
        for i in [0..navNum-1]
            navContainerWidth = navContainerWidth + _navBtns.eq(i).width()
        _navBtnContainer.css('width',navContainerWidth)
        navContaienrMright= -(navContainerWidth/2)
        moveNav(currentPage)

        pageA.initLayout()
        pageB.initLayout()
        pageC.initLayout()

        for i in [0..pageNum-1]
            if _pageItems.eq(i).height() > winHeight
                pagerHeight = 20*_pageItems.eq(i).height()/winHeight
                _pagerItems.eq(i).css('height',pagerHeight+'px')

        _pager.css(
            'top':'50%'
            'margin-top':20-_pager.height()/2+'px'
        )
        canGoNext = true

        pageContainerHeight = 0
        for i in [0..pageNum-1]
            pageContainerHeight = pageContainerHeight + _pageItems.eq(i).height()
        _pageContainer.css('height',pageContainerHeight+'px')
        movePage(currentPage)

        _topIcons.eq(currentIcon).addClass('active')
        _topIcons.eq(currentIcon).find('.top-icon-text').show(200)

    initPager = ->
        for i in [0..pageNum-1]
            _pager.append("<li></li>")
        _pagerItems = _pager.find('li')

    #绑定事件
    bindEvents = ->
        _pageContainer.on('mousewheel', onMouseWheel)
        $(window).on('resize', onWinResize)
        _navBtns.on('click', onNavClick)
        _topIcons.on('mouseover', onTopIconActive)
        $('#btn_tiyanqu').on('mouseover',onBtnTiYanQuHover)
        $('#btn_tiyanqu').on('mouseout',onBtnTiYanQuOut)

    onMouseWheel = (e) ->
        scrollPage(e.deltaY)

    onNavClick = (e) ->
        if currentPage != $(this).index()
            changePage($(this).index())
            canGoNext = true

    onWinResize = (e) ->
        initLayout()

    onTopIconActive = (e) ->
        iconId = $(this).index()
        if iconId != currentIcon
            _topIcons.eq(currentIcon).removeClass('active')
            _topIcons.eq(currentIcon).find('.top-icon-text').hide(200)
            _topIcons.eq(iconId).addClass('active')
            _topIcons.eq(iconId).find('.top-icon-text').show(200)
            currentIcon = iconId
    onBtnTiYanQuHover = (e) ->
        $('#top_tip').show()

    onBtnTiYanQuOut    = (e) ->
        $('#top_tip').hide()

    #鼠标滚轮翻页
    scrollPage = (direction) ->
        inPageScroll = false
        scrollStartPos = 0
        scrollEndPos = 0
        if _pageItems.eq(currentPage).height() > winHeight && _pageItems.eq(currentPage).offset().top <= 0 && _pageItems.eq(currentPage).offset().top >= winHeight - _pageItems.eq(currentPage).height()
            inPageScroll = true
            for i in [0..currentPage]
                if i == 0
                    scrollStartPos = 0
                    scrollEndPos = -_pageItems.eq(0).height()
                else
                    scrollStartPos = scrollStartPos - _pageItems.eq(i-1).height()
                    scrollEndPos = scrollEndPos - _pageItems.eq(i).height()
            scrollEndPos = scrollEndPos + winHeight
        if direction > 0
            if inPageScroll
                if _pageItems.eq(currentPage).offset().top < 0
                    canGoNext = false
                    targetPos = scrollStartPos + _pageItems.eq(currentPage).offset().top + inpageScrollSpeed
                    targetPagerPos = parseFloat(_pagerSelector.css('top')) - inpageScrollSpeed*_pagerItems.eq(currentPage).height()/_pageItems.eq(currentPage).height()
                    if targetPos >= scrollStartPos
                        targetPagerPos = parseFloat(_pagerSelector.css('top')) - (inpageScrollSpeed-targetPos+scrollStartPos)*_pagerItems.eq(currentPage).height()/_pageItems.eq(currentPage).height()
                        targetPos = scrollStartPos
                        if canGoNextTimer
                            clearTimeout(canGoNextTimer)
                        canGoNextTimer = setTimeout(setCanGoNext,canGoNextTime/4)
                    _pageContainer.css('top',targetPos)
                    #_pageContainer.stop().animate(
                    #    {
                    #        top: targetPos
                    #    },
                    #    {
                    #        duration: 100,
                    #        easing: 'swing'
                    #    }
                    #)
                    _pagerSelector.css('top',targetPagerPos)
                    #_pagerSelector.stop().animate(
                    #    {
                    #        top:targetPagerPos
                    #    },
                    #    {
                    #        duration: 100,
                    #        easing: 'swing'
                    #    }
                    #)
            if canGoNext
                if currentPage > 0
                    changePage(currentPage - 1)
                canGoNext = false
                if canGoNextTimer
                    clearTimeout(canGoNextTimer)
                canGoNextTimer = setTimeout(setCanGoNext,canGoNextTime)
        else if direction < 0
            if inPageScroll
                if _pageItems.eq(currentPage).offset().top > winHeight - _pageItems.eq(currentPage).height()
                    canGoNext = false
                    targetPos = scrollStartPos + _pageItems.eq(currentPage).offset().top - inpageScrollSpeed
                    targetPagerPos = parseFloat(_pagerSelector.css('top')) + inpageScrollSpeed*_pagerItems.eq(currentPage).height()/_pageItems.eq(currentPage).height()
                    if targetPos <= scrollEndPos
                        targetPagerPos = parseFloat(_pagerSelector.css('top')) + (inpageScrollSpeed-scrollEndPos+targetPos)*_pagerItems.eq(currentPage).height()/_pageItems.eq(currentPage).height()
                        targetPos = scrollEndPos
                        if canGoNextTimer
                            clearTimeout(canGoNextTimer)
                        canGoNextTimer = setTimeout(setCanGoNext,canGoNextTime/4)
                    _pageContainer.css('top',targetPos)
                    #_pageContainer.stop().animate(
                    #    {
                    #        top: targetPos
                    #    },
                    #    {
                    #        duration: 100,
                    #        easing: 'swing'
                    #    }
                    #)
                    _pagerSelector.css('top',targetPagerPos)
                    #_pagerSelector.stop().animate(
                    #    {
                    #        top:targetPagerPos
                    #    },
                    #    {
                    #        duration: 100,
                    #        easing: 'swing'
                    #    }
                    #)
            if canGoNext
                if currentPage < pageNum - 1
                    changePage(currentPage + 1)
                canGoNext = false
                if canGoNextTimer
                    clearTimeout(canGoNextTimer)
                canGoNextTimer = setTimeout(setCanGoNext,canGoNextTime)


    #切换到指定页面
    changePage = (targetPage) ->
        movePage(targetPage)
        moveNav(targetPage)
        if targetPage == 0
            pageA.startSlider()
        else if targetPage == 1
            pageB.initLayout()
        else if targetPage == 2
            pageC.initLayout()
        currentPage = targetPage


    #设置滚轮可翻页
    setCanGoNext = ->
        canGoNext = true

    #翻页控制
    movePage = (page) ->
        targetPos = 0
        if page >= 1
            for i in [1..page]
                if i < page
                    targetPos = targetPos - _pageItems.eq(i).height()
                else
                    if _pageItems.eq(i).height() >= winHeight
                        targetPos = targetPos - winHeight
                    else
                        targetPos = targetPos - _pageItems.eq(i).height()
        _pageContainer.stop().animate(
            {
                top: targetPos
            },
            {
                duration: pageTime,
                easing: 'easeInOutExpo'
            }
        )
        _pagerSelector.stop().animate(
            {
                top:_pagerItems.eq(page).offset().top-_pager.offset().top+2
            },
            {
                duration: pageTime,
                easing: 'easeInOutExpo'
            }
        )

    #根据当前页码控制顶部栏和导航栏动画
    moveNav = (page) ->
        if page < navNum
            _navBtns.filter('.active').removeClass('active')
            _navBtns.eq(page).addClass('active')
        #顶部栏和导航栏动画控制
        if page == 0
            if hideTopBar
                _topBar.stop().animate(
                    {
                        top:0
                    },
                    {
                        duration: pageTime,
                        easing: 'easeInOutExpo'
                    }
                )
                _navBar.stop().animate(
                    {
                        top:40,
                        backgroundColor:'rgba(255,255,255,1)'
                    },
                    {
                        duration: pageTime,
                        easing: 'easeInOutExpo'
                    }
                )
            else
                _navBar.stop().animate(
                    {
                        backgroundColor:'rgba(255,255,255,1)'
                    },
                    {
                        duration: pageTime,
                        easing: 'easeInOutExpo'
                    }
                )
            _navBtnContainer.stop().animate(
                {
                    right:'0%'
                    marginRight:124
                },
                {
                    duration: pageTime,
                    easing: 'easeInOutExpo'
                }
            )
            _navTiyanBtn.stop().animate(
                {
                    right:-500
                }
                {
                    duration: pageTime,
                    easing: 'easeInOutExpo'
                }
            )
        else
            if hideTopBar
                _topBar.stop().animate(
                    {
                        top:-40
                    },
                    {
                        duration: pageTime,
                        easing: 'easeInOutExpo'
                    }
                )
                _navBar.stop().animate(
                    {
                        top:0,
                        backgroundColor:'rgba(255,255,255,0.9)'
                    },
                    {
                        duration: pageTime,
                        easing: 'easeInOutExpo'
                    }
                )
            else
                _navBar.stop().animate(
                    {
                        backgroundColor:'rgba(255,255,255,0.9)'
                    },
                    {
                        duration: pageTime,
                        easing: 'easeInOutExpo'
                    }
                )
            _navBtnContainer.stop().animate(
                {
                    right:'50%'
                    marginRight:navContaienrMright,
                },
                {
                    duration: pageTime,
                    easing: 'easeInOutExpo'
                }
            )
            _navTiyanBtn.stop().animate(
                {
                    right:170
                }
                {
                    duration: pageTime,
                    easing: 'easeInOutExpo'
                }
            )
$ ->
    app = new App()
