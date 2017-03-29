data = {}
defaults = {
  container: 'body'
  spacing: 20
  actions:
    next:
      text: 'Next'
      class: ''
    finish:
      text: 'Finish'
      class: ''
  entries: [
    {
      selector: '#example'
      text: 'this is example'
      onEnter: ()-> console.log 'enter'
      onExit: ()-> console.log 'exit'
    }
  ]
}

tooltipTemplate = [
  '<div class="pageintro-tooltip">',
  '<div class="pageintro-text"></div>',
  '<ul class="pageintro-nav"></ul>',
  '<div class="pageintro-actions"></div>',
  '</div>'
].join('')

holeTemplate = '<div class="pageintro-hole"></div>'
overlayTemplate = '<div class="pageintro-overlay"></div>'

$nav = null
$hole = null
$overlay = null
$tooltip = null
$container = null

init = (options)->
  data = $.extend {}, defaults, options
  $container = $(data.container)
  $hole = $(holeTemplate).hide()
  $overlay = $(overlayTemplate).hide()
  $tooltip = $(tooltipTemplate).hide()
  $nav = $tooltip.find('.pageintro-nav')
  $overlay.append $hole, $tooltip
  $container.append $overlay

  for entry, i in data.entries
    entry.$target = $(entry.selector)
    $li = $('<li/>').on 'click', i, (e)-> select e.data
    $nav.append $li

  actions = data.actions
  $actions = $tooltip.find('.pageintro-actions')
  $btnNext = $('<a class="btn-next" href="#">' + actions.next.text + '</a>')
  $btnFinish = $('<a class="btn-finish" href="#">' + actions.finish.text + '</a>')
  $btnNext.addClass(actions.next.class).on 'click', ()-> select data.step + 1
  $btnFinish.addClass(actions.finish.class).on 'click', finish
  $actions.append $btnNext, $btnFinish

getPosition = ($target)->
  position = $target.offset()
  rootPosition = $(data.container).offset()
  {
    left: position.left - rootPosition.left
    top: position.top - rootPosition.top
  }

setTooltipPosition = (position, size)->
  selfWidth = $tooltip.outerWidth()
  selfHeight = $tooltip.outerHeight()
  methods =
    left: (force)->
      height = Math.min $(window).height(), size.height
      result =
        left: position.left - selfWidth - data.spacing
        top: position.top + (height - selfHeight) / 2

      if force
        if result.left < 0
          result.left = 0
      else
        if result.left < 0
          return false
        if result.top + selfHeight > $(window).height()
          return false

      if result.top < 0
        result.top = data.spacing

      $tooltip.css result
      $tooltip.addClass 'direction-left'
      return true

    right: (force)->
      height = Math.min $(window).height(), size.height
      result =
        left: position.left + size.width + data.spacing
        top: position.top + (height - selfHeight) / 2

      if force
        if result.left + selfWidth > $(window).width()
          result.left = $(window).width() - selfWidth
      else
        if result.left + selfWidth > $(window).width()
          return false
        if result.top + selfHeight > $(window).height()
          return false

      if result.top < 0
        result.top = data.spacing
      $tooltip.css result
      $tooltip.addClass 'direction-right'
      return true

    top: (force)->
      result =
        left: position.left + (size.width - selfWidth) / 2
        top: position.top - selfHeight - data.spacing

      if force
        if result.top < 0
          result.top = 0
      else
        if result.top < 0
          return false

      $tooltip.css result
      $tooltip.addClass 'direction-top'
      return true

    bottom: (force)->
      result =
        left: position.left + (size.width - selfWidth) / 2
        top: position.top + size.height + data.spacing

      if force
        if result.top + selfHeight > $(window).height()
          result.top = $(window).height() - selfHeight
      else
        if result.top + selfHeight > $(window).height()
          return false

      $tooltip.css result
      $tooltip.addClass 'direction-bottom'
      return true

  for direction of methods
    if methods[direction]()
      return
  methods['left'](true)

select = (num)->
  if typeof data.step != 'undefined' and num != data.step
    entry = data.entries[data.step]
    entry.onExit() if entry.onExit

  entry = data.entries[num]
  if entry.onEnter and num != data.step
    entry.onEnter()
  data.step = num
  $tooltip.find('.pageintro-text').text entry.text
  $nav.find('li').eq(num).addClass('active').siblings().removeClass('active')

  if num < data.entries.length - 1
    $tooltip.find('.btn-finish').hide()
    $tooltip.find('.btn-next').show()
  else
    $tooltip.find('.btn-finish').show()
    $tooltip.find('.btn-next').hide()

  position = getPosition entry.$target
  size = 
    width: entry.$target.outerWidth()
    height: entry.$target.outerHeight()

  setTooltipPosition position, size
  $hole.css position
  $hole.css size

update = ()->
  select data.step

start = ()->
  $(window).on 'resize', update
  $container.addClass('pageintro')
  $tooltip.show()
  $overlay.show()
  $hole.show()
  select 0

finish = ()->
  $tooltip.hide()
  $overlay.hide()
  $hole.hide()
  $(window).off 'resize', update
  $container.removeClass('pageintro')

@PageIntro =
  init: init
  start: start
  finish: finish
