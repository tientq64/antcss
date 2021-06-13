require! {fs, dayjs}
process.chdir __dirname

negate = (target) ->
	obj = {}
	for k, val of target
		k = k
			.split " "
			.map (\__ +)
			.join " "
		obj[k] = "__#val"
	obj

empty = (key, target) ->
	key += ""
	obj = {...target}
	for k of obj
		ks = k.split " "
		index = ks.indexOf key
		if index >= 0
			ks[index] = ""
			ks .= join " "
			obj[ks] = obj[k]
			delete obj[k]
			break
	obj

excl = (...keys, target) ->
	obj = {...target}
	for key in keys
		delete obj[key]
	obj

repeat = (a, b, mapFn) ->
	obj = {}
	do
		res = if mapFn => mapFn a else (a): a
		unless res instanceof Object
			res = (a): res
		obj <<< res
	while a++ < b
	obj

map = (arr, mapFn) ->
	obj = {}
	for val in arr
		res = if mapFn => mapFn val else (val): val
		unless res instanceof Object
			res = (val): res
		obj <<< res
	obj

each = (target, mapFn) ->
	obj = {}
	for k, val of target
		obj[k] = mapFn k, val
	obj

eachStr = (target, chrJoin, mapFn) ->
	text = []
	for k, val of target
		text.push mapFn k, val
	text.join chrJoin

props = (props, ...targets) ->
	props = castArray props
	obj = {}
	for target in targets
		for k, val of target
			css = []
			for prop in props
				css.push "#prop:#val"
			obj[k] = css.join \;
	obj

float = (num) ->
	+num - /^0(?=.)/

unit = (num, unit) ->
	num and num + unit or num

castArray = (val) ->
	if Array.isArray val => val else [val]

breakpoints =
	"": ""
	S: "max-width:767px"
	M: "min-width:768px"

spaces3 =
	3: \.75rem
	4: \1rem
	5: \1.25rem
	6: \1.5rem
	7: \1.75rem
	8: \2rem
	9: \2.25rem
	10: \2.5rem
	11: \2.75rem
	12: \3rem
	13: \3.25rem
	14: \3.5rem
	15: \3.75rem
	16: \4rem
	18: \4.5rem
	20: \5rem
	22: \5.5rem
	24: \6rem
	26: \6.5rem
	28: \7rem
	30: \7.5rem
	32: \8rem

spacesP = {
	p: \1px
	1: \.25rem
	2: \.5rem
	...spaces3
}

spaces0 = {
	0: 0
	...spacesP
}

percents4 =
	"-3": \25%
	"-6": \50%
	"-9": \75%
	f: \100%

percents12 = {
	...percents4
	"-1": \8.33333%
	"-2": \16.66667%
	"-4": \33.33333%
	"-5": \41.66667%
	"-7": \58.33333%
	"-8": \66.66667%
	"-10": \83.33333%
	"-11": \91.66667%
}

opacities =
	0: 0
	5: \.05
	10: \.1
	20: \.2
	25: \.25
	30: \.3
	40: \.4
	50: \.5
	60: \.6
	70: \.7
	75: \.75
	80: \.8
	90: \.9
	95: \.95
	100: 1

positions =
	c: \center
	t: \top
	r: \right
	b: \bottom
	l: \left
	tl: "top left"
	tr: "top right"
	br: "bottom right"
	bl: "bottom left"

colors =
	k: "0,0,0"
	w: "255,255,255"
	0: "249,250,251"
	1: "243,244,246"
	2: "229,231,235"
	3: "209,213,219"
	4: "156,163,175"
	5: "107,114,128"
	6: "75,85,99"
	7: "55,65,81"
	8: "31,41,55"
	9: "17,24,39"
	r0: "254,242,242"
	r1: "254,226,226"
	r2: "254,202,202"
	r3: "252,165,165"
	r4: "248,113,113"
	r5: "239,68,68"
	r6: "220,38,38"
	r7: "185,28,28"
	r8: "153,27,27"
	r9: "127,29,29"
	y0: "255,251,235"
	y1: "254,243,199"
	y2: "253,230,138"
	y3: "252,211,77"
	y4: "251,191,36"
	y5: "245,158,11"
	y6: "217,119,6"
	y7: "180,83,9"
	y8: "146,64,14"
	y9: "120,53,15"
	g0: "236,253,245"
	g1: "209,250,229"
	g2: "167,243,208"
	g3: "110,231,183"
	g4: "52,211,153"
	g5: "16,185,129"
	g6: "5,150,105"
	g7: "4,120,87"
	g8: "6,95,70"
	g9: "6,78,59"
	b0: "239,246,255"
	b1: "219,234,254"
	b2: "191,219,254"
	b3: "147,197,253"
	b4: "96,165,250"
	b5: "59,130,246"
	b6: "37,99,235"
	b7: "29,78,216"
	b8: "30,64,175"
	b9: "30,58,138"

tranCurColor = {
	t: \transparent
	c: \currentColor
}

blends =
	m: \normal
	y: \multiply
	r: \screen
	o: \overlay
	d: \darken
	l: \lighten
	cd: \color-dodge
	cb: \color-burn
	hl: \hard-light
	sl: \soft-light
	f: \difference
	x: \exclusion
	h: \hue
	s: \saturation
	c: \color
	u: \luminosity

list =
	"":
		k: \display:block
		i: \display:inline-block
		in: \display:inline
		"f,fC,fCr,fR,fRr": "display:flex;justify-content:center;align-items:center"
		"g,gC,gCd,gR,gRd,gc1,gc2,gc3,gc4,gc5,gc6,gc7,gc8,gc9,gc10,gc11,gc12,gcN,gr1,gr2,gr3,gr4,gr5,gr6,grN": \display:grid
		tb: \display:table
		it: \display:inline-table
		fr: \display:flow-root
		ct: \display:contents
		li: \display:list-item
		n: \display:none
		"a,af": \position:absolute
		af: "left:0;top:0;width:100%;height:100%"
		e: \position:relative
		fx: \position:fixed
		st: \position:static
		sk: \position:sticky
	____:
		"if,ifC,ifCr,ifR,ifRr": "display:inline-flex;justify-content:center;align-items:center"
		"ig,igC,igCd,igR,igRd": \display:inline-grid
	bk:
		props \box-decoration-break,
			"": \slice
			c: \clone
	bz:
		props \box-sizing,
			"": \border-box
			c: \content-box
	fl:
		props \float,
			"": \right
			l: \left
			n: \none
	cl:
		props \clear,
			l: \left
			r: \right
			"": \both
			n: \none
	ob:
		props \object-fit,
			c: \contain
			"": \cover
			f: \fill
			n: \none
			s: \scale-down
	op:
		props \object-position,
			empty \c positions
	o_:
		props \overflow,
			a: \auto
			h: \hidden
			v: \visible
			s: \scroll
			o: \overlay
	ox:
		props \overflow-x,
			a: \auto
			h: \hidden
			v: \visible
			s: \scroll
			o: \overlay
		"": "overflow-x:auto;overflow-y:hidden"
		l: "overflow-x:overlay;overflow-y:hidden"
	oy:
		props \overflow-y,
			a: \auto
			h: \hidden
			v: \visible
			s: \scroll
			o: \overlay
		"": "overflow-x:hidden;overflow-y:auto"
		l: "overflow-x:hidden;overflow-y:overlay"
	os:
		props \overscroll-behavior,
			a: \auto
			"": \contain
			n: \none
	osx:
		props \overscroll-behavior-x,
			a: \auto
			"": \contain
			n: \none
	osy:
		props \overscroll-behavior-y,
			a: \auto
			"": \contain
			n: \none
	sb:
		props \scroll-behavior,
			"": \smooth
			a: \auto
		"n::-webkit-scrollbar": "display:none"
		n: "scrollbar-width:none"
	t:
		props \top,
			empty 0 spaces0
			negate spacesP
			percents4
			negate percents4
			a: \auto
	r:
		props \right,
			empty 0 spaces0
			negate spacesP
			percents4
			negate percents4
			a: \auto
	b:
		props \bottom,
			empty 0 spaces0
			negate spacesP
			percents4
			negate percents4
			a: \auto
	l:
		props \left,
			empty 0 spaces0
			negate spacesP
			percents4
			negate percents4
			a: \auto
	v_:
		props \visibility,
			v: \visible
			h: \hidden
	z:
		props \z-index,
			"": 0
			1: 1
			2: 2
			3: 3
			4: 4
			5: 5
			"__1": -1
			a: \auto
	f:
		props \flex,
			1: "1 1 0"
			a: "1 1 auto"
			i: "0 1 auto"
			n: \none
		props \flex-direction,
			r: \row
			c: \column
			rr: \row-reverse
			cr: \column-reverse
		props \flex-wrap,
			w: \wrap
			r: \wrap-reverse
			o: \nowrap
	if:
		props \flex-direction,
			r: \row
			c: \column
			rr: \row-reverse
			cr: \column-reverse
	fg:
		props \flex-grow,
			0: 0
			"": 1
	fk:
		props \flex-shrink,
			0: 0
			"": 1
	od:
		props \order,
			repeat 0 12
			f: -9999
			l: 9999
	g:
		props \grid-auto-flow,
			r: \row
			c: \column
			rd: "row dense"
			cd: "column dense"
	ig:
		props \grid-auto-flow,
			r: \row
			c: \column
			rd: "row dense"
			cd: "column dense"
	gc:
		props \grid-template-columns,
			repeat 1 12 ~>
				(it): "repeat(#it,minmax(0,1fr))"
				"A#it": "repeat(#it,auto)"
			n: \none
	gr:
		props \grid-template-rows,
			repeat 1 6 ~>
				(it): "repeat(#it,minmax(0,1fr))"
				"A#it": "repeat(#it,auto)"
			n: \none
	gw:
		props \grid-column,
			repeat 1 12 ~> "span #it/span #it"
			"": \1/-1
			a: \auto
	gs:
		props \grid-column-start,
			empty 1 (repeat 1 13)
			a: \auto
	ge:
		props \grid-column-end,
			empty 13 (repeat 1 13)
			a: \auto
	gh:
		props \grid-row,
			repeat 1 6 ~> "span #it/span #it"
			"": \1/-1
			a: \auto
	ghs:
		props \grid-row-start,
			empty 1 (repeat 1 7)
			a: \auto
	ghe:
		props \grid-row-end,
			empty 7 (repeat 1 7)
			a: \auto
	gac:
		props \grid-auto-columns,
			a: \auto
			mi: \min-content
			ma: \max-content
			fr: "minmax(0,1fr)"
			repeat 1 12 ~>
				unit (float (1 / it * 100)toFixed 5), \%
	ga:
		props \grid-auto-rows,
			a: \auto
			mi: \min-content
			ma: \max-content
			fr: "minmax(0,1fr)"
			repeat 1 6 ~>
				unit (float (1 / it * 100)toFixed 5), \%
	g_:
		props \gap,
			spaces0
	gx:
		props \column-gap,
			spaces0
	gy:
		props \row-gap,
			spaces0
	j:
		props \justify-content,
			s: \flex-start
			e: \flex-end
			"": \center
			b: \space-between
			r: \space-around
			v: \space-evenly
	ji:
		props \justify-items,
			s: \flex-start
			e: \flex-end
			"": \center
			h: \stretch
	js:
		props \justify-self,
			s: \flex-start
			e: \flex-end
			"": \center
			h: \stretch
			a: \auto
	ac:
		props \align-content,
			s: \flex-start
			e: \flex-end
			"": \center
			b: \space-between
			r: \space-around
			v: \space-evenly
	a:
		props \align-items,
			s: \flex-start
			e: \flex-end
			c: \center
			b: \baseline
			h: \stretch
	as:
		props \align-self,
			s: \flex-start
			e: \flex-end
			"": \center
			h: \stretch
			a: \auto
	p:
		props \padding,
			empty 3 spaces0
	px:
		props [\padding-left \padding-right],
			empty 3 spaces0
	py:
		props [\padding-top \padding-bottom],
			empty 3 spaces0
	pt:
		props \padding-top,
			empty 3 spaces0
	pr:
		props \padding-right,
			empty 3 spaces0
	pb:
		props \padding-bottom,
			empty 3 spaces0
	pl:
		props \padding-left,
			empty 3 spaces0
	m:
		props \margin,
			empty 3 spaces0
			negate spacesP
			a: \auto
	mx:
		props [\margin-left \margin-right],
			empty 3 spaces0
			negate spacesP
			a: \auto
	my:
		props [\margin-top \margin-bottom],
			empty 3 spaces0
			negate spacesP
			a: \auto
	mt:
		props \margin-top,
			empty 3 spaces0
			negate spacesP
			a: \auto
	mr:
		props \margin-right,
			empty 3 spaces0
			negate spacesP
			a: \auto
	mb:
		props \margin-bottom,
			empty 3 spaces0
			negate spacesP
			a: \auto
	ml:
		props \margin-left,
			empty 3 spaces0
			negate spacesP
			a: \auto
	w:
		props \width,
			spaces0
			empty \f percents12
			a: \auto
			v: \100vw
			i: \min-content
			x: \max-content
	wi:
		props \min-width,
			spaces0
			empty \f percents12
			a: \auto
			v: \100vw
			i: \min-content
			x: \max-content
	wx:
		props \max-width,
			spaces0
			empty \f percents12
			a: \auto
			v: \100vw
			i: \min-content
			x: \max-content
	h:
		props \height,
			spaces0
			empty \f percents12
			a: \auto
			v: \100vh
	hi:
		props \min-height,
			spaces0
			empty \f percents12
			a: \auto
			v: \100vh
	hx:
		props \max-height,
			spaces0
			empty \f percents12
			a: \auto
			v: \100vh
	ff:
		props \font-family,
			"": "Roboto,sans-serif"
			s: "Roboto Slab,serif"
			m: "Mononoki,monospace"
	fz:
		props \font-size,
			1: \.625rem
			2: \.75rem
			3: \.875rem
			"": \1rem
			5: \1.125rem
			6: \1.25rem
			7: \1.5rem
			8: \1.875rem
			9: \2.25rem
			10: \3rem
			11: \3.75rem
			12: \4.5rem
			13: \6rem
			14: \8rem
	fs:
		props \font-style,
			"": \italic
			m: \normal
	fw:
		props \font-weight,
			empty 7 repeat 1 9 ~> it * 100
	ls:
		props \letter-spacing,
			"": 0
			"1": \.025em
			"2": \.05em
			"3": \.1em
			__1: \__.025em
			__2: \__.05em
	lh:
		props \line-height,
			4: 1
			"": 1.25
			6: 1.375
			7: 1.5
			8: 1.625
			9: 2
	lt:
		props \list-style-type,
			"": \none
			d: \disc
			m: \decimal
			s: \square
			c: \circle
	lp:
		props \list-style-position,
			i: \inside
			o: \outside
	t_:
		props \text-align,
			l: \left
			r: \right
			c: \center
			j: \justify
	c:
		props \color,
			tranCurColor
		each colors, (k, v) ~>
			"--co:1;color:rgba(#v,var(--co))"
	co:
		props \--co,
			opacities
	td:
		props \text-decoration,
			u: \underline
			l: \line-through
			"": \none
	tt:
		props \text-transform,
			"": \uppercase
			l: \lowercase
			c: \capitalize
			n: \none
	to:
		"": "overflow:hidden;text-overflow:ellipsis;white-space:nowrap"
		c: "overflow:hidden;text-overflow:clip;white-space:nowrap"
	tc:
		d: "-webkit-text-security:disc;text-security:disc"
		c: "-webkit-text-security:circle;text-security:circle"
		"": "-webkit-text-security:square;text-security:square"
		n: "-webkit-text-security:none;text-security:none"
	___:
		"lc1,lc,lc3,lc4,lc5,lc6": "--lc:2;display:-webkit-box;overflow:hidden;-webkit-box-orient:vertical;-webkit-line-clamp:var(--lc)"
	lc:
		empty 2 repeat 1 6 ~>
			"--lc:#it"
	v:
		props \vertical-align,
			t: \top
			p: \text-top
			"": \middle
			l: \baseline
			m: \text-bottom
			b: \bottom
	ws:
		props \white-space,
			m: \normal
			"": \nowrap
			p: \pre
			l: \pre-line
			w: \pre-wrap
	wb:
		props \word-break,
			m: \normal
			"": \break-word
			b: \break-all
			k: \keep-all
	da:
		props \background-attachment,
			"": \fixed
			l: \local
			s: \scroll
	dc:
		props \background-clip,
			b: \border-box
			"": \padding-box
			c: \content-box
	d:
		props \background-color,
			tranCurColor
			n: \none
		each colors, (k, v) ~>
			"--bgo:1;background-color:rgba(#v,var(--bgo))"
	do:
		props \--bgo,
			empty 50 opacities
	dp:
		props \background-position,
			empty \c positions
	dr:
		props \background-repeat,
			r: \repeat
			"": \no-repeat
			x: \repeat-x
			y: \repeat-y
			o: \round
			s: \space
	dz:
		props \background-size,
			a: \auto
			c: \contain
			"": \cover
	di:
		props: \background-image,
			"": \none
	br:
		props \border-radius,
			empty 3 spaces0[0 1 2 3 4 5 6]
			f: \9999px
	brt:
		props [\border-top-left-radius \border-top-right-radius],
			empty 3 spaces0[0 1 2 3 4 5 6]
			f: \9999px
	brr:
		props [\border-top-right-radius \border-bottom-right-radius],
			empty 3 spaces0[0 1 2 3 4 5 6]
			f: \9999px
	brb:
		props [\border-bottom-right-radius \border-bottom-left-radius],
			empty 3 spaces0[0 1 2 3 4 5 6]
			f: \9999px
	brl:
		props [\border-top-left-radius \border-bottom-left-radius],
			empty 3 spaces0[0 1 2 3 4 5 6]
			f: \9999px
	btl:
		props \border-top-left-radius,
			empty 3 spaces0[0 1 2 3 4 5 6]
			f: \9999px
	btr:
		props \border-top-right-radius,
			empty 3 spaces0[0 1 2 3 4 5 6]
			f: \9999px
	bbr:
		props \border-bottom-right-radius,
			empty 3 spaces0[0 1 2 3 4 5 6]
			f: \9999px
	bbl:
		props \border-bottom-left-radius,
			empty 3 spaces0[0 1 2 3 4 5 6]
			f: \9999px
	bs:
		props \border-style,
			"": \solid
			d: \dashed
			o: \dotted
			n: \none
	bw:
		props \border-width,
			0: 0
			2: \2px
			4: \4px
			8: \8px
			"": \1px
	bwt:
		props \border-top-width,
			0: 0
			2: \2px
			4: \4px
			8: \8px
			"": \1px
	bwr:
		props \border-right-width,
			0: 0
			2: \2px
			4: \4px
			8: \8px
			"": \1px
	bwb:
		props \border-bottom-width,
			0: 0
			2: \2px
			4: \4px
			8: \8px
			"": \1px
	bwl:
		props \border-left-width,
			0: 0
			2: \2px
			4: \4px
			8: \8px
			"": \1px
	bc:
		props \border-color,
			tranCurColor
		each colors, (k, v) ~>
			"--bo:1;border-color:rgba(#v,var(--bo))"
	bo:
		props \--bo,
			empty 50 opacities
	sh:
		props \box-shadow,
			1: "0 1px 2px 0 rgba(0,0,0,.05)"
			"": "0 1px 3px 0 rgba(0,0,0,.1),0 1px 2px 0 rgba(0,0,0,.06)"
			3: "0 4px 6px -1px rgba(0,0,0,.1),0 2px 4px -1px rgba(0,0,0,.06)"
			4: "0 10px 15px -3px rgba(0,0,0,.1),0 4px 6px -2px rgba(0,0,0,.05)"
			5: "0 20px 25px -5px rgba(0,0,0,.1),0 10px 10px -5px rgba(0,0,0,.04)"
			6: "0 25px 50px -12px rgba(0,0,0,.25)"
			i: "0 2px 4px 0 rgba(0,0,0,.06)inset"
			n: \none
	o:
		props \opacity,
			empty 50 opacities
	bm:
		props \mix-blend-mode,
			empty \m blends
	bgb:
		props \background-blend-mode,
			empty \m blends
	ft:
		props \filter,
			"": "var(--ftL) var(--ftB) var(--ftC) var(--ftG) var(--ftH) var(--ftI) var(--ftS) var(--ftP)"
			n: \none
	ftL:
		0: "--ftL:blur(0)"
		empty 8 map [4 8 12 16 24 40 64] ~>
			"--ftL:blur(#{it}px)"
	ftB:
		map [0 50 75 90 95 100 105 110 125 150 200] ~>
			"--ftB:brightness(#{float it / 100})"
	ftC:
		map [0 50 75 100 125 150 200] ~>
			"--ftC:contrast(#{float it / 100})"
	ftG:
		empty 1 map [0 1] ~>
			"--ftG:grayscale(#it)"
	ftH:
		map [0 15 30 60 90 180] ~>
			"--ftH:hue-rotate(#{it}deg)"
		map [15 30 60 90 180] ~>
			["__#it" "--ftH:hue-rotate(-#{it}deg)"]
	ftI:
		empty 1 map [0 1] ~>
			"--ftI:invert(#it)"
	ftS:
		map [0 50 100 150 200] ~>
			"--ftS:saturate(#{float it / 100})"
	ftP:
		empty 1 map [0 1] ~>
			"--ftP:sepia(#it)"
	bp:
		props \border-collapse,
			c: \collapse
			"": \separate
	tl:
		props \table-layout,
			a: \auto
			"": \fixed
	ts:
		",tf,o,sh,c,pz,75,100,150,200,300,500,700,1000": "transition:.15s cubic-bezier(.25,1,.5,1)"
	ts_:
		props \transition-property,
			tf: \transform
			o: \opacity
			sh: \box-shadow
			c: "background-color,color,border-color,fill,stroke"
			pz: "left,top,right,bottom,width,height"
		n: \transition:none
		map [75 100 150 200 300 500 700 1000] ~>
			"transition-duration:#{float it / 1000}s"
	tst:
		props \transition-timing-function,
			l: \linear
			"": "cubic-bezier(.25,1,.5,1)"
			i: "cubic-bezier(.5,0,.75,0)"
			io: "cubic-bezier(.76,0,.24,1)"
	tsd:
		map [75 100 150 200 300 500 700 1000] ~>
			"transition-delay:#{float it / 1000}s"
	am:
		props \animation,
			"": "am 1s linear infinite"
			n: \none
	_:
		"x0,xP,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x18,x20,x22,x24,x26,x28,x30,x32,__xP,__x1,__x2,__x3,__x4,__x5,__x6,__x7,__x8,__x9,__x10,__x11,__x12,__x13,__x14,__x15,__x16,__x18,__x20,__x22,__x24,__x26,__x28,__x30,__x32,x-3,x-6,x-9,x,__x-3,__x-6,__x-9,__x,y0,yP,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15,y16,y18,y20,y22,y24,y26,y28,y30,y32,__yP,__y1,__y2,__y3,__y4,__y5,__y6,__y7,__y8,__y9,__y10,__y11,__y12,__y13,__y14,__y15,__y16,__y18,__y20,__y22,__y24,__y26,__y28,__y30,__y32,y-3,y-6,y-9,y,__y-3,__y-6,__y-9,__y,xy,rt0,rt45,rt90,rt135,rt180,__rt45,__rt90,__rt135,__rt180,s0,s50,s75,s90,s95,s100,s105,s110,s125,s150,sx0,sx50,sx75,sx90,sx95,sx100,sx105,sx110,sx125,sx150,sy0,sy50,sy75,sy90,sy95,sy100,sy105,sy110,sy125,sy150,kx0,kx1,kx2,kx3,kx6,kx12,__kx1,__kx2,__kx3,__kx6,__kx12,ky0,ky1,ky2,ky3,ky6,ky12,__ky1,__ky2,__ky3,__ky6,__ky12": "--x:0;--y:0;--rt:0;--sx:1;--sy:1;--kx:0;--ky:0;transform:translate(var(--x),var(--y))rotate(var(--rt))scale(var(--sx),var(--sy))skew(var(--kx),var(--ky))"
	tf:
		3: "--x:0;--y:0;--rt:0;--sx:1;--sy:1;--kx:0;--ky:0;transform:translate3d(var(--x),var(--y),0)rotate(var(--rt))scale(var(--sx),var(--sy))skew(var(--kx),var(--ky))"
		n: \transform:none
		props \transform-origin,
			positions
	x:
		props \--x,
			spaces0
			negate spacesP
			empty \f percents4
			negate empty \f percents4
	y:
		props \--y,
			spaces0
			negate spacesP
			empty \f percents4
			negate empty \f percents4
	xy:
		"": "--x:-50%;--y:-50%"
	rt:
		map [0 45 90 135 180] ~>
			"--rt:#{unit it, \deg}"
		map [45 90 135 180] ~>
			"__#it": "--rt:-#{unit it, \deg}"
	s:
		props [\--sx \--sy],
			map [0 50 75 90 95 100 105 110 125 150] ~>
				float it / 100
	sx:
		map [0 50 75 90 95 100 105 110 125 150] ~>
			"--sx:#{float it / 100}"
	sy:
		map [0 50 75 90 95 100 105 110 125 150] ~>
			"--sy:#{float it / 100}"
	kx:
		map [0 1 2 3 6 12] ~>
			"--kx:#{unit it, \deg}"
		map [1 2 3 6 12] ~>
			"__#it": "--kx:-#{unit it, \deg}"
	ky:
		map [0 1 2 3 6 12] ~>
			"--ky:#{unit it, \deg}"
		map [1 2 3 6 12] ~>
			"__#it": "--ky:-#{unit it, \deg}"
	ap:
		props \appearance,
			"": \none
	cs:
		props \cursor,
			"": \pointer
			w: \wait
			t: \text
			m: \move
			h: \help
			0: \not-allowed
			i: \zoom-in
			o: \zoom-out
			c: \copy
			r: \crosshair
			g: \grab
			b: \grabing
			d: \default
			a: \auto
			n: \none
	ol:
		"": \outline:0
		0: \box-shadow:none
		1: "--oo:1;box-shadow:0 0 0 1px var(--oc)"
		2: "--oo:1;box-shadow:0 0 0 2px var(--oc)"
		3: "--oo:1;box-shadow:0 0 0 3px var(--oc)"
		4: "--oo:1;box-shadow:0 0 0 4px var(--oc)"
		8: "--oo:1;box-shadow:0 0 0 8px var(--oc)"
	oc:
		props \--oc,
			tranCurColor
		each colors, (k, v) ~>
			"--oc:rgba(#v,var(--oo))"
	oo:
		props \--oo,
			empty 50 opacities
	pe:
		props \pointer-events,
			a: \auto
			"": \none
	rz:
		props \resize,
			b: \both
			w: \horizontal
			"": \vertical
			n: \none
	u:
		props \user-select,
			t: \text
			l: \all
			a: \auto
			"": \none
	ud:
		e: "-webkit-user-drag:element;user-drag:element"
		a: "-webkit-user-drag:auto;user-drag:auto"
		"": "-webkit-user-drag:none;user-drag:none"
	__:
		"a1,ax1,ax2,ax3,ax4,ax5,ax6,ax7,ax,ax9,ax10,ax11,ax12,ax13,ax14,ax15,ax16,ay1,ay2,ay3,ay4,ay5,ay6,ay7,ay,ay9,ay10,ay11,ay12,ay13,ay14,ay15,ay16": "--ax:8;--ay:8;aspect-ratio:var(--ax)/var(--ay)"
	ax:
		empty 8 map [1 to 16] ~>
			"--ax:#it"
	ay:
		empty 8 map [1 to 16] ~>
			"--ay:#it"

{version} = JSON.parse fs.readFileSync \package.json
date = dayjs!format \YYYY-MM-DD

css = """
	:root{--bo:1;-moz-tab-size:2;tab-size:2}
	*,*:before,*:after{border:solid 0 rgba(209,213,219,var(--bo));box-sizing:border-box}
	*{-webkit-tap-highlight-color:transparent}
	html{line-height:1.25;-webkit-text-size-adjust:100%}
	body{margin:0;font-family:sans-serif}
	small{font-size:80%}
	button,input,select,textarea{border-radius:0;font-family:inherit;font-size:100%;line-height:inherit}
	textarea{resize:vertical}
	fieldset{margin:0}
	ul{list-style-type:square}
	table{border-collapse:collapse}
	@keyframes am{from{transform:rotate(0)}to{transform:rotate(360deg)}}
"""
css =
	"/*! antcss, v#version, #date */\n" + css.replace /\n/g ""
readme = """
	# AntCSS :ant:

	Utility CSS framework with abbreviated class names.

	> AntCSS is like ants, small and many but powerful.<br>
	> AntCSS inspired by [Emmet](https://github.com/emmetio/emmet) and [Tailwind CSS](https://github.com/tailwindlabs/tailwindcss).

	## Usage

	Using CDN:

	https://cdn.jsdelivr.net/npm/antcss@#version/ant.min.css

	## Syntax

	`sign + breakpoint + class`

	[sign](): As sign "-" if the value is negative

	[breakpoint](\#breakpoints): If defined, it will apply exactly that breakpoint

	[class](\#classes): Class

	## Breakpoints

	Prefix   | Media
	-------- | -----
	\\<none> | \\<none>
	`S`      | max-width: 767px
	`M`      | min-width: 768px

	## Classes

	Class | CSS
	----- | ---
"""
abbrs = []
for k of list""
	k = k.split \, .0
	if k and not abbrs.includes k
		abbrs.push k

for k1, v1 of list
	k1 -= /_+$/
	v1 = castArray v1
	if k1 and not abbrs.includes k1
		abbrs.push k1
	for bp, media of breakpoints
		if bp
			css += "@media(#media){"
		for v2 in v1
			for k3, v3 of v2
				readme += \\n unless bp
				k3 = k3.split \,
				v3 .= replace /__/g \-
				stors = []
				for k4 in k3
					if k4.includes \__
						sign = \-
						k4 -= \__
					else
						sign = ""
					if k1
						k4 = k4.charAt(0)toUpperCase! + k4.substring 1
					stors.push ".#sign#bp#k1#k4"
				unless bp
					readme += stors
						.map ~> "`#{it.substring 1}`"
						.join " "
					text = v3
						.replace /:/g ": "
						.replace /;/g \;<br>
					readme += " | #text;"
				stors .= join \,
				css += "#stors{#v3}"
		if bp
			css += \}

readme += \\n
abbrs = abbrs
	.sort (a, b) ~>
		a.localeCompare b
	.join \\n

fs.writeFileSync \ant.min.css css
fs.writeFileSync \README.md readme
fs.writeFileSync \abbrs.txt abbrs

console.log """
	> ant.min.css - #{(css.length / 1000)toFixed 2} KB
	> README.md - #{(readme.length / 1000)toFixed 2} KB
"""
