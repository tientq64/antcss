require! {fs}
process.chdir __dirname

negate = (target) ->
	obj = {}
	for k, val of target
		k .= replace /^| /g \$&__
		obj[k] = "__#val"
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

map = (arr, defl, mapFn) ->
	if typeof defl is \function
		[defl, mapFn] = [, defl]
	obj = {}
	for val in arr
		prop = if val is defl => "" else val
		res = if mapFn => mapFn val else (prop): val
		unless res instanceof Object
			res = (prop): res
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
	num - /^0(?=.)/

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
	"1-2 2-4": \50%
	"1-3": \33.33333%
	"2-3": \66.66667%
	"1-4": \25%
	"3-4": \75%
	f: \100%

percents12 = {
	"1-2 2-4 3-6 6-12": \50%
	"1-3 2-6 4-12": \33.33333%
	"2-3 4-6 8-12": \66.66667%
	"1-4 3-12": \25%
	"3-4 9-12": \75%
	"1-5": \20%
	"2-5": \40%
	"3-5": \60%
	"4-5": \80%
	"1-6 2-12": \16.66667%
	"5-6 10-12": \83.33333%
	"1-12": \8.33333%
	"5-12": \41.66667%
	"7-12": \58.33333%
	"11-12": \91.66667%
	f: \100%
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
	w: "250,250,250"
	a1: "249,250,251"
	a2: "243,244,246"
	a3: "229,231,235"
	a4: "209,213,219"
	a5: "156,163,175"
	a6: "107,114,128"
	a7: "75,85,99"
	a8: "55,65,81"
	a9: "31,41,55"
	a10: "17,24,39"
	r1: "254,242,242"
	r2: "254,226,226"
	r3: "254,202,202"
	r4: "252,165,165"
	r5: "248,113,113"
	r6: "239,68,68"
	r7: "220,38,38"
	r8: "185,28,28"
	r9: "153,27,27"
	r10: "127,29,29"
	y1: "255,251,235"
	y2: "254,243,199"
	y3: "253,230,138"
	y4: "252,211,77"
	y5: "251,191,36"
	y6: "245,158,11"
	y7: "217,119,6"
	y8: "180,83,9"
	y9: "146,64,14"
	y10: "120,53,15"
	g1: "236,253,245"
	g2: "209,250,229"
	g3: "167,243,208"
	g4: "110,231,183"
	g5: "52,211,153"
	g6: "16,185,129"
	g7: "5,150,105"
	g8: "4,120,87"
	g9: "6,95,70"
	g10: "6,78,59"
	b1: "239,246,255"
	b2: "219,234,254"
	b3: "191,219,254"
	b4: "147,197,253"
	b5: "96,165,250"
	b6: "59,130,246"
	b7: "37,99,235"
	b8: "29,78,216"
	b9: "30,64,175"
	b10: "30,58,138"

trCc = {
	tr: \transparent
	cc: \currentColor
}

blends =
	nm: \normal
	ml: \multiply
	sc: \screen
	ov: \overlay
	dk: \darken
	lg: \lighten
	cd: \color-dodge
	cb: \color-burn
	hl: \hard-light
	sl: \soft-light
	df: \difference
	ex: \exclusion
	he: \hue
	sa: \saturation
	cl: \color
	lm: \luminosity

list =
	bxdb:
		props \box-decoration-break,
			sl: \slice
			cl: \clone
	bxz:
		props \box-sizing,
			bd: \border-box
			ct: \content-box
	d:
		props \display,
			bl: \block
			ib: \inline-block
			in: \inline
			fx: \flex
			if: \inline-flex
			tb: \table
			it: \inline-table
			fr: \flow-root
			gd: \grid
			ig: \inline-grid
			ct: \contents
			li: \list-item
			hd: \hidden
	fl:
		props \float,
			r: \right
			l: \left
			n: \none
	cl:
		props \clear,
			l: \left
			r: \right
			bo: \both
			n: \none
	obf:
		props \object-fit,
			cn: \contain
			cv: \cover
			fi: \fill
			n: \none
			sc: \scale-down
	obp:
		props \object-position,
			positions
	ov:
		props \overflow,
			a: \auto
			hd: \hidden
			vs: \visible
			sc: \scroll
	ovx:
		props \overflow-x,
			a: \auto
			hd: \hidden
			vs: \visible
			sc: \scroll
	ovy:
		props \overflow-y,
			a: \auto
			hd: \hidden
			vs: \visible
			sc: \scroll
	ovsb:
		props \overscroll-behavior,
			a: \auto
			cn: \contain
			n: \none
	ovsbx:
		props \overscroll-behavior-x,
			a: \auto
			cn: \contain
			n: \none
	ovsby:
		props \overscroll-behavior-y,
			a: \auto
			cn: \contain
			n: \none
	ps:
		props \position,
			st: \static
			fd: \fixed
			ab: \absolute
			rl: \relative
			sy: \sticky
	in:
		props \inset,
			0: 0
	t:
		props \top,
			spaces0
			negate spacesP
			percents4
			negate percents4
			a: \auto
	r:
		props \right,
			spaces0
			negate spacesP
			percents4
			negate percents4
			a: \auto
	b:
		props \bottom,
			spaces0
			negate spacesP
			percents4
			negate percents4
			a: \auto
	l:
		props \left,
			spaces0
			negate spacesP
			percents4
			negate percents4
			a: \auto
	vb:
		props \visibility,
			vs: \visible
			hd: \hidden
	z:
		props \z-index,
			0: 0
			1: 1
			2: 2
			3: 3
			4: 4
			5: 5
			"__1": -1
			a: \auto
	fxd:
		props \flex-direction,
			rw: \row
			co: \column
			rv: \row-reverse
			cv: \column-reverse
	fxw:
		props \flex-wrap,
			wr: \wrap
			wv: \wrap-reverse
			nw: \nowrap
	fx:
		props \flex,
			1: "1 1 0"
			a: "1 1 auto"
			i: "0 1 auto"
			n: \none
	fxg:
		props \flex-grow,
			0: 0
			1: 1
	fxs:
		props \flex-shrink,
			0: 0
			1: 1
	od:
		props \order,
			repeat 0 12
			fs: -9999
			ls: 9999
	gdtc:
		props \grid-template-columns,
			repeat 1 12 ~> "repeat(#it,auto)"
			n: \none
	gdc:
		props \grid-column,
			repeat 1 12 ~> "span #it/span #it"
			f: \1/-1
			a: \auto
	gdcs:
		props \grid-column-start,
			repeat 1 13
			a: \auto
	gdce:
		props \grid-column-end,
			repeat 1 13
			a: \auto
	gdtr:
		props \grid-template-rows,
			repeat 1 6 ~> "repeat(#it,auto)"
			n: \none
	gdr:
		props \grid-row,
			repeat 1 6 ~> "span #it/span #it"
			f: \1/-1
			a: \auto
	gdrs:
		props \grid-row-start,
			repeat 1 7
			a: \auto
	gdre:
		props \grid-row-end,
			repeat 1 7
			a: \auto
	gdaf:
		props \grid-auto-flow,
			rw: \row
			co: \column
			rd: "row dense"
			cd: "column dense"
	gdar:
		props \grid-auto-rows,
			a: \auto
			mi: \min-content
			ma: \max-content
			fr: "minmax(0,1fr)"
	gdac:
		props \grid-auto-columns,
			a: \auto
			mi: \min-content
			ma: \max-content
			fr: "minmax(0,1fr)"
	gp:
		props \gap,
			spaces0
	gpx:
		props \column-gap,
			spaces0
	gpy:
		props \row-gap,
			spaces0
	jc:
		props \justify-content,
			st: \flex-start
			en: \flex-end
			c: \center
			bw: \space-between
			ar: \space-around
			ev: \space-evenly
	ji:
		props \justify-items,
			st: \flex-start
			en: \flex-end
			c: \center
			tr: \stretch
	js:
		props \justify-self,
			st: \flex-start
			en: \flex-end
			c: \center
			tr: \stretch
			a: \auto
	ac:
		props \align-content,
			st: \flex-start
			en: \flex-end
			c: \center
			bw: \space-between
			ar: \space-around
			ev: \space-evenly
	ai:
		props \align-items,
			st: \flex-start
			en: \flex-end
			c: \center
			bs: \baseline
			tr: \stretch
	as:
		props \align-self,
			st: \flex-start
			en: \flex-end
			c: \center
			tr: \stretch
			a: \auto
	p:
		props \padding,
			spaces0
	px:
		props [\padding-left \padding-right],
			spaces0
	py:
		props [\padding-top \padding-bottom],
			spaces0
	pt:
		props \padding-top,
			spaces0
	pr:
		props \padding-right,
			spaces0
	pb:
		props \padding-bottom,
			spaces0
	pl:
		props \padding-left,
			spaces0
	m:
		props \margin,
			spaces0
			negate spacesP
			a: \auto
	mx:
		props [\margin-left \margin-right],
			spaces0
			negate spacesP
			a: \auto
	my:
		props [\margin-top \margin-bottom],
			spaces0
			negate spacesP
			a: \auto
	mt:
		props \margin-top,
			spaces0
			negate spacesP
			a: \auto
	mr:
		props \margin-right,
			spaces0
			negate spacesP
			a: \auto
	mb:
		props \margin-bottom,
			spaces0
			negate spacesP
			a: \auto
	ml:
		props \margin-left,
			spaces0
			negate spacesP
			a: \auto
	w:
		props \width,
			spaces0
			percents12
			a: \auto
			sc: \100vw
			mi: \min-content
			ma: \max-content
	miw:
		props \min-width,
			spaces0
			percents12
			a: \auto
			sc: \100vw
			mi: \min-content
			ma: \max-content
	maw:
		props \max-width,
			spaces0
			percents12
			a: \auto
			sc: \100vw
			mi: \min-content
			ma: \max-content
	h:
		props \height,
			spaces0
			percents12
			a: \auto
			sc: \100vh
	mih:
		props \min-height,
			spaces0
			percents12
			a: \auto
			sc: \100vh
	mah:
		props \max-height,
			spaces0
			percents12
			a: \auto
			sc: \100vh
	ff:
		props \font-family,
			ss: "Roboto,sans-serif"
			sr: "Roboto Slab,serif"
			mn: "Cascadia Mono,monospace"
	fz:
		props \font-size,
			spaces3
	fs:
		props \font-style,
			il: \italic
			nm: \normal
	fw:
		props \font-weight,
			repeat 1 9 ~> it * 100
	ls:
		props \letter-spacing,
			0: 0
			"0025": \.025em
			"005": \.05em
			"01": \.1em
			__0025: \__.025em
			__005: \__.05em
	lh:
		props \line-height,
			spaces0[3 4 5 6 7 8 9 10]
	lsst:
		props \list-style-type,
			n: \none
			ds: \disc
			dm: \decimal
	lssp:
		props \list-style-position,
			in: \inside
			ou: \outside
	ta:
		props \text-align,
			l: \left
			r: \right
			c: \center
			jf: \justify
	c:
		props \color,
			trCc
		each colors, (k, v) ~>
			"--emCo:1;color:rgba(#v,var(--emCo))"
	co:
		props \--emCo,
			opacities
	td:
		props \text-decoration,
			un: \underline
			th: \line-through
			n: \none
	tt:
		props \text-transform,
			up: \uppercase
			lw: \lowercase
			cp: \capitalize
			n: \none
	to:
		el: "overflow:hidden;text-overflow:ellipsis;white-space:nowrap"
		cp: "overflow:hidden;text-overflow:clip;white-space:nowrap"
	lc:
		repeat 1 6 ~>
			"display:-webkit-box;overflow:hidden;-webkit-box-orient:vertical;-webkit-line-clamp:#it"
	va:
		props \vertical-align,
			t: \top
			tt: \text-top
			m: \middle
			bs: \baseline
			tb: \text-bottom
			b: \bottom
	ws:
		props \white-space,
			nm: \normal
			nw: \nowrap
			pr: \pre
			pl: \pre-line
			pw: \pre-wrap
	wb:
		props \word-break,
			nm: \normal
			bw: \break-word
			ba: \break-all
			ka: \keep-all
	bga:
		props \background-attachment,
			fd: \fixed
			lc: \local
			sc: \scroll
	bgcp:
		props \background-clip,
			bd: \border-box
			pd: \padding-box
			ct: \content-box
	bgc:
		props \background-color,
			trCc
		each colors, (k, v) ~>
			"--emBgo:1;background-color:rgba(#v,var(--emBgo))"
	bgo:
		props \--emBgo,
			opacities
	bgp:
		props \background-position,
			positions
	bgr:
		props \background-repeat,
			rp: \repeat
			nr: \no-repeat
			rx: \repeat-x
			ry: \repeat-y
			rn: \round
			sp: \space
	bgz:
		props \background-size,
			a: \auto
			cn: \contain
			cv: \cover
	bgi:
		props: \background-image,
			n: \none
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
	brtl:
		props \border-top-left-radius,
			spaces0[0 1 2 3 4 5 6]
			f: \9999px
	brtr:
		props \border-top-right-radius,
			spaces0[0 1 2 3 4 5 6]
			f: \9999px
	brbr:
		props \border-bottom-right-radius,
			spaces0[0 1 2 3 4 5 6]
			f: \9999px
	brbl:
		props \border-bottom-left-radius,
			spaces0[0 1 2 3 4 5 6]
			f: \9999px
	bdw:
		props \border-width,
			0: 0
			2: \2px
			4: \4px
			8: \8px
			"": \1px
	bdwt:
		props \border-top-width,
			0: 0
			2: \2px
			4: \4px
			8: \8px
			"": \1px
	bdwr:
		props \border-right-width,
			0: 0
			2: \2px
			4: \4px
			8: \8px
			"": \1px
	bdwb:
		props \border-bottom-width,
			0: 0
			2: \2px
			4: \4px
			8: \8px
			"": \1px
	bdwl:
		props \border-left-width,
			0: 0
			2: \2px
			4: \4px
			8: \8px
			"": \1px
	bdc:
		props \border-color,
			trCc
		each colors, (k, v) ~>
			"--emBdo:1;border-color:rgba(#v,var(--emBdo))"
	bdo:
		props \--emBdo,
			opacities
	bds:
		props \border-style,
			sl: \solid
			ds: \dashed
			do: \dotted
			n: \none
	rg:
		props \box-shadow,
			n: \none
			"": "var(--emRgi) 0 0 0 3px var(--emRgc)"
			0: "var(--emRgi) 0 0 0 0 var(--emRgc)"
			1: "var(--emRgi) 0 0 0 1px var(--emRgc)"
			2: "var(--emRgi) 0 0 0 2px var(--emRgc)"
			4: "var(--emRgi) 0 0 0 4px var(--emRgc)"
			8: "var(--emRgi) 0 0 0 8px var(--emRgc)"
	rgc:
		props \--emRgc,
			trCc
		each colors, (k, v) ~>
			"--emRgc:rgba(#v,var(--emRgo))"
	rgo:
		props \--emRgo,
			opacities
	bsh:
		props \box-shadow,
			1: "0 1px 2px 0 rgba(0,0,0,.05)"
			"": "0 1px 3px 0 rgba(0,0,0,.1),0 1px 2px 0 rgba(0,0,0,.06)"
			3: "0 4px 6px -1px rgba(0,0,0,.1),0 2px 4px -1px rgba(0,0,0,.06)"
			4: "0 10px 15px -3px rgba(0,0,0,.1),0 4px 6px -2px rgba(0,0,0,.05)"
			5: "0 20px 25px -5px rgba(0,0,0,.1),0 10px 10px -5px rgba(0,0,0,.04)"
			6: "0 25px 50px -12px rgba(0,0,0,.25)"
			in: "0 2px 4px 0 rgba(0,0,0,.06)inset"
			n: \none
	op:
		props \opacity,
			opacities
	mbm:
		props \mix-blend-mode,
			blends
	bgbm:
		props \background-blend-mode,
			blends
	ft:
		props \filter,
			"": "var(--emFtBl) var(--emFtBr) var(--emFtCt) var(--emFtGs) var(--emFtHe) var(--emFtIv) var(--emFtSa) var(--emFtSp)"
			n: \none
	ftBl:
		0: "--emFtBl:blur(0)"
		map [4 8 12 16 24 40 64] 8 ~>
			"--emFtBl:blur(#{it}px)"
	ftBr:
		map [0 50 75 90 95 100 105 110 125 150 200] ~>
			"--emFtBr:brightness(#{float it / 100})"
	ftCt:
		map [0 50 75 100 125 150 200] ~>
			"--emFtCt:contrast(#{float it / 100})"
	ftGs:
		map [0 1] 1 ~>
			"--emFtGs:grayscale(#it)"
	ftHe:
		map [0 15 30 60 90 180] ~>
			"--emFtHe:hue-rotate(#{it}deg)"
		map [15 30 60 90 180] ~>
			["__#it" "--emFtHe:hue-rotate(-#{it}deg)"]
	ftIv:
		map [0 1] 1 ~>
			"--emFtIv:invert(#it)"
	ftSa:
		map [0 50 100 150 200] ~>
			"--emFtSa:saturate(#{float it / 100})"
	ftSp:
		map [0 1] 1 ~>
			"--emFtSp:sepia(#it)"
	bdcl:
		props \border-collapse,
			cl: \collapse
			sp: \separate
	tbl:
		props \table-layout,
			a: \auto
			fd: \fixed
	tr:
		props: \transition,
			"": "transition:.15s cubic-bezier(.08,.69,.23,.94)"
			tf: "transition:transform .15s cubic-bezier(.08,.69,.23,.94)"
			op: "transition:opacity .15s cubic-bezier(.08,.69,.23,.94)"
			sh: "transition:box-shadow .15s cubic-bezier(.08,.69,.23,.94)"
			cl: "transition-property:background-color,border-color,color,fill,stroke;transition-duration:.15s;transition-timing-function:cubic-bezier(.08,.69,.23,.94)"
			n: \transition:none
	trd:
		map [75 100 150 200 300 500 700 1000] ~>
			"transition-duration:#{float it / 1000}s"
	trt:
		props \transition-timing-function,
			ln: \linear
			out: "cubic-bezier(.08,.69,.23,.94)"
			in: "cubic-bezier(.77,.06,.92,.31)"
			io: "cubic-bezier(.76,.08,.23,.94)"
	tre:
		map [75 100 150 200 300 500 700 1000] ~>
			"transition-delay:#{float it / 1000}s"
	am:
		props \animation,
			rt: "emAmRo 1s linear infinite"
			n: \none
	tf:
		"": "--emTftx:0;--emTfty:0;--emTfr:0;--emTfkx:0;--emTfky:0;--emTfsx:1;--emTfsy:1;transform:translate(var(--emTftx),var(--emTfty))rotate(var(--emTfr))skew(var(--emTfkx),var(--emTfky))scale(var(--emTfsx),var(--emTfsy))"
		"3d": "--emTftx:0;--emTfty:0;--emTfr:0;--emTfkx:0;--emTfky:0;--emTfsx:1;--emTfsy:1;transform:translate3d(var(--emTftx),var(--emTfty),0)rotate(var(--emTfr))skew(var(--emTfkx),var(--emTfky))scale(var(--emTfsx),var(--emTfsy))"
		n: \transform:none
	tfs:
		props [\--emTfsx \--emTfsy],
			map [0 50 75 90 95 100 105 110 125 150] ~>
				float it / 100
	tfsx:
		map [0 50 75 90 95 100 105 110 125 150] ~>
			"--emTfsx:#{float it / 100}"
	tfsy:
		map [0 50 75 90 95 100 105 110 125 150] ~>
			"--emTfsy:#{float it / 100}"
	tfr:
		map [0 45 90 135 180] ~>
			"--emTfr:#{unit it, \deg}"
		map [45 90 135 180] ~>
			"__#it": "--emTfr:-#{unit it, \deg}"
	tftx:
		props \--emTftx,
			spaces0
			negate spacesP
			percents4
			negate percents4
	tfty:
		props \--emTfty,
			spaces0
			negate spacesP
			percents4
			negate percents4
	tfo:
		props \transform-origin,
			positions

css = "@keyframes emAmRo{from{transform:rotate(0)}to{transform:rotate(360deg)}}"
readme = """
	# AntCSS :ant:

	Utility CSS framework with abbreviated class names.

	> AntCSS is like ants, small and many but powerful.<br>
	> AntCSS inspired by [Emmet](https://github.com/emmetio/emmet).

	## Usage

	Using CDN:

	https://cdn.jsdelivr.net/npm/antcss/ant.css

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

function handle bp, media
	if bp
		css += "@media(#media){"
	for k1, v1 of list
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

fs.writeFileSync \em.css css
fs.writeFileSync \README.md readme
