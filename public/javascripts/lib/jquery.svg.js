/**
 * The SVG DOM is different so we need some custom
 * methods here to work with SVG objects
 */
$.fn.addSVGClass = function(c) {
  return this.each(function(i) {
    var cl = this.getAttribute('class')

    if(!cl) cl = ' ';    
    cl = cl.split(' ')
    if(cl.indexOf(c) == -1) {
      cl.push(c)
      this.setAttribute('class', cl.join(' '))
    }
  })
}

$.fn.removeSVGClass = function(c) {
  var el = this[0]
      cl = el.getAttribute('class')
      
  cl = cl.split(' ')
  var idx = cl.indexOf(c)
  if(idx != -1) {
    cl.splice(idx, 1)
    el.setAttribute('class', cl.join(' '))
  }
  
  return this
}

$.fn.hasSVGClass = function(c) {
  var el = this[0]
      cl = el.getAttribute('class')
      has = false
      
  cl = cl.split(' ')
  var idx = cl.indexOf(c)
  if(idx != -1)
    has = true
    
  return has
}