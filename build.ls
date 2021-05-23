require! {fs}
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
	0: "250,250,249"
	1: "245,245,244"
	2: "231,229,228"
	3: "214,211,209"
	4: "168,162,158"
	5: "120,113,108"
	6: "87,83,78"
	7: "68,64,60"
	8: "41,37,36"
	9: "28,25,23"
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
		bl: \display:block
		ib: \display:inline-block
		f: "display:flex;justify-content:center;align-items:center"
		if: "display:inline-flex;justify-content:center;align-items:center"
		g: \display:grid
		ig: \display:inline-grid
		n: \display:none
		ab: \position:absolute
		af: "position:absolute;left:0;top:0;width:100%;height:100%"
		rl: \position:relative
		fd: \position:fixed
	bd:
		props \box-decoration-break,
			"": \slice
			c: \clone
	bz:
		props \box-sizing,
			"": \border-box
			c: \content-box
	d:
		props \display,
			"": \inline
			t: \table
			it: \inline-table
			f: \flow-root
			c: \contents
			l: \list-item
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
	ox:
		props \overflow-x,
			a: \auto
			h: \hidden
			v: \visible
			s: \scroll
		"": "overflow-x:auto;overflow-y:hidden"
	oy:
		props \overflow-y,
			a: \auto
			h: \hidden
			v: \visible
			s: \scroll
		"": "overflow-x:hidden;overflow-y:auto"
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
	ps:
		props \position,
			"": \static
			y: \sticky
	i:
		props \inset,
			"": 0
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
	vb:
		props \visibility,
			v: \visible
			"": \hidden
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
			1: 1
			a: \auto
			i: \initial
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
	g_:
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
	gx:
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
	gy:
		props \grid-row,
			repeat 1 6 ~> "span #it/span #it"
			"": \1/-1
			a: \auto
	gys:
		props \grid-row-start,
			empty 1 (repeat 1 7)
			a: \auto
	gye:
		props \grid-row-end,
			empty 7 (repeat 1 7)
			a: \auto
	ga:
		props \grid-auto-columns,
			a: \auto
			mi: \min-content
			ma: \max-content
			fr: "minmax(0,1fr)"
			repeat 1 6 ~>
				unit (float (100 - it / 6 * 100)toFixed 5), \%
	gar:
		props \grid-auto-rows,
			a: \auto
			mi: \min-content
			ma: \max-content
			fr: "minmax(0,1fr)"
			repeat 1 12 ~>
				unit (float (100 / it)toFixed 5), \%
	g:
		props \gap,
			spaces0
	gw:
		props \column-gap,
			spaces0
	gh:
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
			"": \center
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
			m: "Cascadia Mono,monospace"
	fz:
		props \font-size,
			spaces3
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
		props \lihe-height,
			4: 1
			"": 1.25
			6: 1.5
			7: 1.75
			8: 2
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
	ta:
		props \text-align,
			l: \left
			r: \right
			"": \center
			j: \justify
	c:
		props \color,
			tranCurColor
		each colors, (k, v) ~>
			"--antCo:1;color:rgba(#v,var(--antCo))"
	co:
		props \--antCo,
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
	lc:
		empty 2 repeat 1 6 ~>
			"display:-webkit-box;overflow:hidden;-webkit-box-orient:vertical;-webkit-line-clamp:#it"
	va:
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
	bga:
		props \background-attachment,
			"": \fixed
			l: \local
			s: \scroll
	bgc:
		props \background-clip,
			b: \border-box
			"": \padding-box
			c: \content-box
	bg:
		props \background-color,
			tranCurColor
			n: \none
		each colors, (k, v) ~>
			"--antBgo:1;background-color:rgba(#v,var(--antBgo))"
	bgo:
		props \--antBgo,
			empty 50 opacities
	bgp:
		props \background-position,
			empty \c positions
	bgr:
		props \background-repeat,
			r: \repeat
			"": \no-repeat
			x: \repeat-x
			y: \repeat-y
			o: \round
			s: \space
	bgz:
		props \background-size,
			a: \auto
			c: \contain
			"": \cover
	bgi:
		props: \background-image,
			"": \none
	br:
		props \border-radius,
			spaces0[0 1 2 3 4 5 6]
			f: \9999px
	brt:
		props [\border-top-left-radius \border-top-right-radius],
			spaces0[0 1 2 3 4 5 6]
			f: \9999px
	brr:
		props [\border-top-right-radius \border-bottom-right-radius],
			spaces0[0 1 2 3 4 5 6]
			f: \9999px
	brb:
		props [\border-bottom-right-radius \border-bottom-left-radius],
			spaces0[0 1 2 3 4 5 6]
			f: \9999px
	brl:
		props [\border-top-left-radius \border-bottom-left-radius],
			spaces0[0 1 2 3 4 5 6]
			f: \9999px
	btl:
		props \border-top-left-radius,
			spaces0[0 1 2 3 4 5 6]
			f: \9999px
	btr:
		props \border-top-right-radius,
			spaces0[0 1 2 3 4 5 6]
			f: \9999px
	bbr:
		props \border-bottom-right-radius,
			spaces0[0 1 2 3 4 5 6]
			f: \9999px
	bbl:
		props \border-bottom-left-radius,
			spaces0[0 1 2 3 4 5 6]
			f: \9999px
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
			"--antBo:1;border-color:rgba(#v,var(--antBo))"
	bo:
		props \--antBo,
			empty 50 opacities
	bs:
		props \border-style,
			"": \solid
			d: \dashed
			o: \dotted
			n: \none
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
			"": "var(--antFtL) var(--antFtB) var(--antFtC) var(--antFtG) var(--antFtH) var(--antFtI) var(--antFtS) var(--antFtP)"
			n: \none
	ftL:
		0: "--antFtL:blur(0)"
		empty 8 map [4 8 12 16 24 40 64] ~>
			"--antFtL:blur(#{it}px)"
	ftB:
		map [0 50 75 90 95 100 105 110 125 150 200] ~>
			"--antFtB:brightness(#{float it / 100})"
	ftC:
		map [0 50 75 100 125 150 200] ~>
			"--antFtC:contrast(#{float it / 100})"
	ftG:
		empty 1 map [0 1] ~>
			"--antFtG:grayscale(#it)"
	ftH:
		map [0 15 30 60 90 180] ~>
			"--antFtH:hue-rotate(#{it}deg)"
		map [15 30 60 90 180] ~>
			["__#it" "--antFtH:hue-rotate(-#{it}deg)"]
	ftI:
		empty 1 map [0 1] ~>
			"--antFtI:invert(#it)"
	ftS:
		map [0 50 100 150 200] ~>
			"--antFtS:saturate(#{float it / 100})"
	ftP:
		empty 1 map [0 1] ~>
			"--antFtP:sepia(#it)"
	bp:
		props \border-collapse,
			c: \collapse
			"": \separate
	tl:
		props \table-layout,
			a: \auto
			"": \fixed
	ts:
		props: \transition,
			"": "transition:.15s cubic-bezier(.08,.69,.23,.94)"
			tf: "transition:transform .15s cubic-bezier(.08,.69,.23,.94)"
			o: "transition:opacity .15s cubic-bezier(.08,.69,.23,.94)"
			sh: "transition:box-shadow .15s cubic-bezier(.08,.69,.23,.94)"
			c: "transition-property:background-color,border-color,color,fill,stroke;transition-duration:.15s;transition-timing-function:cubic-bezier(.08,.69,.23,.94)"
			n: \transition:none
	tsd:
		empty 150 map [75 100 150 200 300 500 700 1000] ~>
			"transition-duration:#{float it / 1000}s"
	tst:
		props \transition-timing-function,
			l: \linear
			"": "cubic-bezier(.08,.69,.23,.94)"
			i: "cubic-bezier(.77,.06,.92,.31)"
			io: "cubic-bezier(.76,.08,.23,.94)"
	tsl:
		map [75 100 150 200 300 500 700 1000] ~>
			"transition-delay:#{float it / 1000}s"
	am:
		props \animation,
			rt: "antAmRt 1s linear infinite"
			n: \none
	tf:
		"": "--antTx:0;--antTy:0;--antRt:0;--antSx:1;--antSy:1;--antKx:0;--antKy:0;transform:translate(var(--antTx),var(--antTy))rotate(var(--antRt))scale(var(--antSx),var(--antSy))skew(var(--antKx),var(--antKy))"
		3: "--antTx:0;--antTy:0;--antRt:0;--antSx:1;--antSy:1;--antKx:0;--antKy:0;transform:translate3d(var(--antTx),var(--antTy),0)rotate(var(--antRt))scale(var(--antSx),var(--antSy))skew(var(--antKx),var(--antKy))"
		n: \transform:none
	tfo:
		props \transform-origin,
			empty \c positions
	tx:
		props \--antTx,
			empty \f spaces0
			negate empty \f spacesP
			percents4
			negate percents4
	ty:
		props \--antTy,
			empty \f spaces0
			negate empty \f spacesP
			percents4
			negate percents4
	rt:
		map [0 45 90 135 180] ~>
			"--antRt:#{unit it, \deg}"
		map [45 90 135 180] ~>
			"__#it": "--antRt:-#{unit it, \deg}"
	sc:
		props [\--antSx \--antSy],
			map [0 50 75 90 95 100 105 110 125 150] ~>
				float it / 100
	sx:
		map [0 50 75 90 95 100 105 110 125 150] ~>
			"--antSx:#{float it / 100}"
	sy:
		map [0 50 75 90 95 100 105 110 125 150] ~>
			"--antSy:#{float it / 100}"
	kx:
		map [0 1 2 3 6 12] ~>
			"--antKx:#{unit it, \deg}"
		map [1 2 3 6 12] ~>
			"__#it": "--antKx:-#{unit it, \deg}"
	ky:
		map [0 1 2 3 6 12] ~>
			"--antKy:#{unit it, \deg}"
		map [1 2 3 6 12] ~>
			"__#it": "--antKy:-#{unit it, \deg}"
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
		props \outline,
			n: \none
		0: \none
		1: "--antOo:1;box-shadow:0 0 0 1px var(--antOc)"
		2: "--antOo:1;box-shadow:0 0 0 2px var(--antOc)"
		"": "--antOo:1;box-shadow:0 0 0 3px var(--antOc)"
		4: "--antOo:1;box-shadow:0 0 0 4px var(--antOc)"
		8: "--antOo:1;box-shadow:0 0 0 8px var(--antOc)"
	oc:
		props \--antOc,
			tranCurColor
		each colors, (k, v) ~>
			"--antOc:rgba(#v,var(--antOo))"
	oo:
		props \--antOo,
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
	us:
		props \user-select,
			t: \text
			l: \all
			a: \auto
			"": \none
	ud:
		e: "-webkit-user-drag:element;user-drag:element"
		a: "-webkit-user-drag:auto;user-drag:auto"
		"": "-webkit-user-drag:none;user-drag:none"
	ar:
		"": "--antAx:8;--antAy:8;aspect-ratio:var(--antAx)/var(--antAy)"
	ax:
		map [1 to 7] ++ [9 to 16] ~>
			"--antAx:#it"
	ay:
		map [1 to 7] ++ [9 to 16] ~>
			"--antAy:#it"

css = '''
	:root{-moz-tab-size:2;tab-size:2}
	*,*:before,*:after{box-sizing:border-box}
	*{-webkit-tap-highlight-color:transparent}
	html{line-height:1.25;-webkit-text-size-adjust:100%}
	body{margin:0;font-family:sans-serif}
	small{font-size:80%}
	button,input,select,textarea{font-family:inherit;font-size:100%}
	textarea{resize:vertical}
	fieldset{margin:0}
	ul{list-style-type:square}
	table{border-collapse:collapse}
	@keyframes antAmRt{from{transform:rotate(0)}to{transform:rotate(360deg)}}
'''
css .= replace /\n/g ""
readme = '''
	# AntCSS :ant:

	Utility CSS framework with abbreviated class names.

	> AntCSS is like ants, small and many but powerful.<br>
	> AntCSS inspired by [Emmet](https://github.com/emmetio/emmet) and [Tailwind CSS](https://github.com/tailwindlabs/tailwindcss).

	## Usage

	Using CDN:

	https://cdn.jsdelivr.net/npm/antcss/ant.css

	## Syntax

	`sign + breakpoint + class`

	[sign](): As sign "-" if the value is negative
	
	[breakpoint](#breakpoints): If defined, it will apply exactly that breakpoint
	
	[class](#classes): Class

	## Breakpoints

	Prefix   | Media
	-------- | -----
	\\<none> | \\<none>
	`S`      | max-width: 767px
	`M`      | min-width: 768px

	## Classes

	Class | CSS
	----- | ---
'''

function handle bp, media
	if bp
		css += "@media(#media){"
	for k1, v1 of list
		k1 -= /_+$/
		v1 = castArray v1
		for v2 in v1
			for k3, v3 of v2
				readme += \\n unless bp
				k3 = k3.split " "
				v3 .= replace /__/g \-
				selectors = []
				for v4 in k3
					sign = v4.includes \__ and \- or ""
					if sign
						v4 -= \__
					if k1
						v4 = v4.charAt(0)toUpperCase! + v4.substring 1
					selectors.push ".#sign#bp#k1#v4"
				unless bp
					readme += selectors
						.map ~> "`#{it.substring 1}`"
						.join " "
					text = v3
						.replace /:/g ": "
						.replace /;/g \;<br>
					readme += " | #text;"
				selectors .= join \,
				css += "#selectors{#v3}"
	if bp
		css += \}

for bp, media of breakpoints
	handle bp, media

readme += \\n

fs.writeFileSync \ant.css css
fs.writeFileSync \README.md readme
