breed [spiders spider]
globals [ scale xmin xmax ]
turtles-own [orbit]

to setup
  ca
  set xmin 0
  set xmax 1
  set-default-shape spiders "spider"
  reset-ticks
  set scale 4.0 ;global scale
  draw-axes
  ask patches [ set pcolor 7 ]
  draw-equation
  tick
end

;;;; add a reporter in this section describing a new curve
to-report eq-logistic [x]
  report R * x * (1 - x)
end

to-report eq-sin [x]
  report R * sin (180 * x)
end

to-report eq-bimodal [x]
  ifelse x < .5 [report R * 2 * x][report R * (2 - 2 * x)]
end
;;;; and add the corresponding name in the "equation" selector.

to-report eq-line [x]
  report R * x
end

to-report eq-parallels [x]
  ifelse x <= .5 [report R * 2 * x][report R * (-1 + 2 * x)]
end

to-report eq [x]
  report runresult (word "eq-" equation " x") ; choose equation
end

to draw-axes
  ;let pc .1
  let desp 0; pc * (xmax - xmin)
  resize-world (xmin - desp) * scale (xmax + desp) * scale (xmin - desp) * scale (xmax + desp) * scale
  set-patch-size 430.0 / world-width
  crt 1 [
    set color black
    pd set heading 0 setxy xmin xmin
    let rx scale * (xmax - xmin)
    fd rx bk rx
    rt 90
    fd rx bk rx
    lt 45
    fd sqrt 2 * rx
    die
  ]
end

to draw-equation
  let resol 300 ; divisions of x-axes
  crt 1 [
    set color red
    let step (xmax - xmin) / resol
    setxy scale * xmin scale * (eq xmin)
    pd
    let x xmin
    repeat resol [
      set x x + step
      pu
      set xcor scale * x
      let y scale * eq x
      if y < (scale * xmax) and y > 0 [ ; no negatives or large values
        pd
        set ycor y
      ]
    ]
    die
  ]
end

to place-new-spider
  loop [
    let halt? false
    if mouse-inside? [
      if mouse-down? and mouse-xcor > xmin * scale and mouse-xcor < xmax * scale [
        if not keep-old-spiders? and any? turtles [ ask turtles [die] ]
        create-spiders 1 [
          if color = 65 or color = 85 [set color 75]
          set size world-width / 33
          setxy mouse-xcor scale * xmin
          set heading 0
          set orbit mouse-xcor / scale
          output-show orbit
          pd
          ;set color red
          set halt? true
        ]
      ]
    ]
    if halt? [tick stop]
  ]
end

to move-spider
  carefully [
    set ycor scale * eq (xcor / scale) ; go to eq
    set xcor ycor ; go to diagonal
  ][ print "Error: spider out of bounds." ]
end

to iterate-web
  carefully [
    ask turtles [
      move-spider
      set orbit xcor / scale
      output-show orbit
    ]
    tick
  ][print "Error: no spiders."]
end
@#$#@#$#@
GRAPHICS-WINDOW
207
29
644
467
-1
-1
86.0
1
10
1
1
1
0
0
0
1
0
4
0
4
1
1
1
ticks
30.0

BUTTON
10
132
76
165
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
8
10
163
70
R
4.0
1
0
Number

BUTTON
12
231
153
264
NIL
place-new-spider
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
12
289
114
322
NIL
iterate-web
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
116
289
202
322
continue
iterate-web
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

OUTPUT
660
30
900
200
10

TEXTBOX
661
15
811
33
Orbits
11
0.0
1

PLOT
659
200
859
350
Youngest spider's orbit
NIL
NIL
0.0
10.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "if any? turtles [\nplot [orbit] of max-one-of turtles [who]]"

CHOOSER
8
69
163
114
equation
equation
"logistic" "sin" "bimodal" "line" "parallels"
0

TEXTBOX
14
266
208
294
(then click mouse within x range)
11
0.0
1

SWITCH
12
181
183
214
keep-old-spiders?
keep-old-spiders?
0
1
-1000

@#$#@#$#@
## Qué es? / WHAT IS IT?

Diagrama de telaraña (iteración) de diferentes funciones, mostrando su órbita.

Spider web diagram (iteration) of different functions, showing their orbit.

## Como funciona / HOW IT WORKS

Los agentes (arañas) después de posicionarse dentro del intervalo [0,1] en el eje x, saltan alternativamente a la curva y a la diagonal de la identidad.

The agents (spiders) after positioning themselves within the interval [0,1] on the x-axis, alternate jumps to the curve and to the diagonal of the identity.

## Como usarlo / HOW TO USE IT

Ajuste el valor para el parámetro R de la ecuación, seleccione la ecuación a usar y con SETUP se dibujan ejes, la diagonal y=x, así como la ecuación seleccionada (también se borran arañas y cualquier dibujo preexistente).
A continuación, pulse place-new-spider para colocar una araña nueva, puede colocar varias si está activado el control keep-old-spiders?, y haga clic dentro del cuadrante (no es necesario sobre el eje x) para colocar el agente iterador (araña).
Después de esto, presione varias veces iterase-web o simplemente presione continue para iterar continuamente.

Set the value for the R parameter of the equation, select the equation to use and SETUP to draw axes, the y=x diagonal, as well as the selected equation (spiders and any pre-existing drawings are also deleted).
Then press place-new-spider to place a new spider, you can place several if the keep-old-spiders? control is activated, and click inside the quadrant (not necessary on the x-axis) to place the iterator agent (spider).
After that, press iterase-web several times or simply press continue to iterate continuously.

## Cosas para observar / THINGS TO NOTICE

Observe que el modelo funciona mientras el agente utilice coordenadas "válidas" (dentro del rango de x). Observe también que el cuadrante es un cuadrado, por lo que los rangos x y y son iguales. Observe los valores de la órbita de las arañas (¿puedes utilizarlos como generador de números aleatorios?) y la curva trazada por la araña más joven (última situada).

Note that the model works as long as the agent uses "valid" coordinates (within the x-range). Note also that the quadrant is a square, so the x and y ranges are equal.
Note the values of the spiders' orbit (can you use them as a random number generator?) and the curve traced by the youngest spider (last placed).

## Cosas para probar / THINGS TO TRY

Mantén la curva dentro de [0,1] variando R, por ejemplo usa 0<R<=4 para la curva logística, 0<R<=1 para la curva sin y la bimodal.
Intenta encontrar atractores y repulsores con diferentes posiciones iniciales de la araña. Puedes crear un nuevo trazado manteniendo el anterior mientras no presiones SETUP.
Intenta crear dos arañas casi en la misma posición. Si la ecuación es caótica su separación se incrementará.

Keep the curve within [0,1] by varying R, e.g. use 0<R<=4 for the logistic curve, 0<R<=1 for the sin curve and the bimodal curve.
Try to find attractors and repellers with different initial positions of the spider. You can create a new trace keeping the previous one as long as you do not press SETUP.
Try to create two spiders in almost the same position. If the equation is chaotic their separation will increase.

## Extendiendo el modelo / EXTENDING THE MODEL

El modelo puede ampliarse fácilmente añadiendo curvas. Defina un reportado llamado eq-xxx siguiendo la misma estructura básica de los del modelo. A continuación, añada la línea "xxx" editando el selector de equation.

The model can be easily extended by adding curves. Define a report called eq-xxx following the same basic structure of those in the model. Then add the line "xxx" by editing the equation selector.

## Características de Netlogo / NETLOGO FEATURES

El código utiliza la constante "scale" que depende del tamaño en parches de una unidad "real". Esto se hizo debido principalmente porque Netlogo tiene que mantener un espacio alrededor del centro de los parches de las esquinas. 
La instrucción "run" nos permite ejecutar cualquier ecuación  o sistema de ecuaciones, que se pueda programar con Netlogo.
Debido a que Netlogo requiere que cada curva sea definida desde un inicio, no es fácil graficar, por ejemplo, las órbitas de cada tortuga.
Hay colores que no contrastan suficiente con el color del fondo, se modificó para que el programa no los tome.
El ratón puede no responder bien a bajas velocidades.

The code uses the constant "scale" which depends on the patch size of a "real" unit. This was done mainly because Netlogo has to maintain a space around the center of the corner patches. 
The "run" instruction allows us to execute any equation or system of equations, which can be programmed with Netlogo.
Because Netlogo requires that each curve be defined from the beginning, it is not easy to plot, for example, the orbits of each turtle.
There are colors that do not contrast sufficiently with the background color, so it was modified so that the program does not take them.
The mouse may not respond well at low speeds.

## Modelos relacionados / RELATED MODELS

Logistic growth

## Créditos y referencias / CREDITS AND REFERENCES

Dr. Felipe Contreras / Posgrado en Ciencias de la Complejidad / Universidad Autónoma de la Ciudad de México [felipe.contreras at uacm.edu.mx] / July 2015, Nov 2022
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

spider
true
0
Polygon -7500403 true true 134 255 104 240 96 210 98 196 114 171 134 150 119 135 119 120 134 105 164 105 179 120 179 135 164 150 185 173 199 195 203 210 194 240 164 255
Line -7500403 true 167 109 170 90
Line -7500403 true 170 91 156 88
Line -7500403 true 130 91 144 88
Line -7500403 true 133 109 130 90
Polygon -7500403 true true 167 117 207 102 216 71 227 27 227 72 212 117 167 132
Polygon -7500403 true true 164 210 158 194 195 195 225 210 195 285 240 210 210 180 164 180
Polygon -7500403 true true 136 210 142 194 105 195 75 210 105 285 60 210 90 180 136 180
Polygon -7500403 true true 133 117 93 102 84 71 73 27 73 72 88 117 133 132
Polygon -7500403 true true 163 140 214 129 234 114 255 74 242 126 216 143 164 152
Polygon -7500403 true true 161 183 203 167 239 180 268 239 249 171 202 153 163 162
Polygon -7500403 true true 137 140 86 129 66 114 45 74 58 126 84 143 136 152
Polygon -7500403 true true 139 183 97 167 61 180 32 239 51 171 98 153 137 162

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
