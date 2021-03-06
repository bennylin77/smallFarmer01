/*___________________________________________________________________________________________________________________________________________________
 _ jquery.mb.components                                                                                                                             _
 _                                                                                                                                                  _
 _ file: jquery.mb.simpleSlider.min.js                                                                                                              _
 _ last modified: 16/05/15 23.45                                                                                                                    _
 _                                                                                                                                                  _
 _ Open Lab s.r.l., Florence - Italy                                                                                                                _
 _                                                                                                                                                  _
 _ email: matteo@open-lab.com                                                                                                                       _
 _ site: http://pupunzi.com                                                                                                                         _
 _       http://open-lab.com                                                                                                                        _
 _ blog: http://pupunzi.open-lab.com                                                                                                                _
 _ Q&A:  http://jquery.pupunzi.com                                                                                                                  _
 _                                                                                                                                                  _
 _ Licences: MIT, GPL                                                                                                                               _
 _    http://www.opensource.org/licenses/mit-license.php                                                                                            _
 _    http://www.gnu.org/licenses/gpl.html                                                                                                          _
 _                                                                                                                                                  _
 _ Copyright (c) 2001-2015. Matteo Bicocchi (Pupunzi);                                                                                              _
 ___________________________________________________________________________________________________________________________________________________*/

! function(a) {
    /iphone|ipod|ipad|android|ie|blackberry|fennec/.test(navigator.userAgent.toLowerCase());
    var c = "ontouchstart" in window || window.navigator && window.navigator.msPointerEnabled && window.MSGesture || window.DocumentTouch && document instanceof DocumentTouch || !1;
    a.simpleSlider = {
        defaults: {
            initialval: 0,
            scale: 100,
            orientation: "h",
            readonly: !1,
            callback: !1
        },
        events: {
            start: c ? "touchstart" : "mousedown",
            end: c ? "touchend" : "mouseup",
            move: c ? "touchmove" : "mousemove"
        },
        init: function(b) {
            return this.each(function() {
                var d = this,
                    e = a(d);
                e.addClass("simpleSlider"), d.opt = {}, a.extend(d.opt, a.simpleSlider.defaults, b), a.extend(d.opt, e.data());
                var f = "h" == d.opt.orientation ? "horizontal" : "vertical",
                    g = a("<div/>").addClass("level").addClass(f);
                e.prepend(g), d.level = g, e.css({
                    cursor: "default"
                }), "auto" == d.opt.scale && (d.opt.scale = a(d).outerWidth()), e.updateSliderVal(), d.opt.readonly || (e.on(a.simpleSlider.events.start, function(a) {
                    c && (a = a.changedTouches[0]), d.canSlide = !0, e.updateSliderVal(a), e.css({
                        cursor: "col-resize"
                    }), a.preventDefault(), a.stopPropagation()
                }), a(document).on(a.simpleSlider.events.move, function(b) {
                    c && (b = b.changedTouches[0]), d.canSlide && (a(document).css({
                        cursor: "default"
                    }), e.updateSliderVal(b), b.preventDefault(), b.stopPropagation())
                }).on(a.simpleSlider.events.end, function() {
                    a(document).css({
                        cursor: "auto"
                    }), d.canSlide = !1, e.css({
                        cursor: "auto"
                    })
                }))
            })
        },
        updateSliderVal: function(b) {
            function g(a, b) {
                return Math.floor(100 * a / b)
            }
            var c = this,
                d = c.get(0);
            d.opt.initialval = "number" == typeof d.opt.initialval ? d.opt.initialval : d.opt.initialval(d);
            var e = a(d).outerWidth(),
                f = a(d).outerHeight();
            d.x = "object" == typeof b ? b.clientX + document.body.scrollLeft - c.offset().left : "number" == typeof b ? b * e / d.opt.scale : d.opt.initialval * e / d.opt.scale, d.y = "object" == typeof b ? b.clientY + document.body.scrollTop - c.offset().top : "number" == typeof b ? (d.opt.scale - d.opt.initialval - b) * f / d.opt.scale : d.opt.initialval * f / d.opt.scale, d.y = c.outerHeight() - d.y, d.scaleX = d.x * d.opt.scale / e, d.scaleY = d.y * d.opt.scale / f, d.outOfRangeX = d.scaleX > d.opt.scale ? d.scaleX - d.opt.scale : d.scaleX < 0 ? d.scaleX : 0, d.outOfRangeY = d.scaleY > d.opt.scale ? d.scaleY - d.opt.scale : d.scaleY < 0 ? d.scaleY : 0, d.outOfRange = "h" == d.opt.orientation ? d.outOfRangeX : d.outOfRangeY, d.value = "undefined" != typeof b ? "h" == d.opt.orientation ? d.x >= c.outerWidth() ? d.opt.scale : d.x <= 0 ? 0 : d.scaleX : d.y >= c.outerHeight() ? d.opt.scale : d.y <= 0 ? 0 : d.scaleY : "h" == d.opt.orientation ? d.scaleX : d.scaleY, "h" == d.opt.orientation ? d.level.width(g(d.x, e) + "%") : d.level.height(g(d.y, f)), "function" == typeof d.opt.callback && d.opt.callback(d)
        }
    }, a.fn.simpleSlider = a.simpleSlider.init, a.fn.updateSliderVal = a.simpleSlider.updateSliderVal
}(jQuery);