# Taller de Interacción: Gamepad como Interacción (En Desarrollo)
![Control](http://newmore.es/2803-large_default/mando-juego-con-vibracion-dual-shock-para-pc.jpg)

## Autor

| Integrante | github nick |
|------------|-------------|
|Juan Sebastián Martínez Beltrán|juasmartinezbel|

## Descripción del Proyecto y Objetivos

Poder formular una forma de interactividad con el ambiente y los objetos creados en Processing, a través de los botones, flechas y sticks de un control de juegos genérico.

Por el momento, únicamente funciona con un control tipo Twin USB Controller configurado en Windows

A la hora de ejecutar el ambiente, se recibirá al usuario en un espacio similar a una galería, donde podrá recorrerlo con los controles, los cuales podrá ver si oprime los botones **R1** o **L1** como invita a hacer la parte superior de la pantalla. 

![translate](https://pbs.twimg.com/media/DesurzXWkAEemf9.jpg)

![controls](https://pbs.twimg.com/media/DeswJfnXUAEbLCl.jpg)

Como se muestra, el usuario podrá trasladarse en los ejes **_X, Y & Z_**, y rotando la camara en primera persona hacia **_X, Y & Z_**, asegurando así los 6 grados de Libertad para recorrer el mundo


![translate](https://pbs.twimg.com/media/DesvccHW4AAmKwK.jpg)

A la hora de seleccionar un modelo cuando el puntero se pone rojo, existirá otro tipo de interacción, donde podremos manipular dicho modelo seleccionado, podremos rotarlo en los ejes **_X, Y & Z_** y, aunque no podamos trasladar el modelo de su posición sobre cada una de las mesas, podremos modificar sus vertices debidamente resaltados en los ejes **_X, Y & Z_**

![model](https://pbs.twimg.com/media/Desw7omWAAEYC4o.jpg)

![model2](https://pbs.twimg.com/media/Desw-N7XkAE2hqZ.jpg)

## Estructura del programa

Se utilizan principalmente 4 pestañas para dividir el trabajo, más una de pruebas

- **GamePadInteractivity:** Lugar principal donde se inicializa todo, se tiene el _setup_ y el _draw_ y se hacen aquí los llamados a las funcionalidades generales
- **Controller:** Lugar donde se tienen todas las posibles combinaciones de botones y acciones que ejecuta dependiendo de la situación.
- **Model:** Lugar donde se tienen funciones relacionadas con la inicialización y uso de modelos _PShape_ y _Shape_
- **ScreenCoordinates:** Lugar donde se tienen funciones para los gráficos que se tienen en frente de la pantalla, como la funcionalidad de los botones y el puntero.

## Cómo Funciona

Lo primero que se hace es inicializar todas las cosas que guardarán valores relacionados cada uno de los modelos, como valores originales de los vertices, los PShapes, los Shapes, qué modelo se va a analizar, posiciones en las que se trasladarán los Shapes de los modelos y los Shapes de las mesas, etc.

A la hora de entrar al draw, se dibujará el ambiente 3D, si usa luces, las mallas, la cantidad de mesas, y cada uno de los modelos instanciados. Y al final dibujará en frente todo lo relacionado con el menú, como lo es el puntero y el mapeo de botones.

El Draw siempre estará escuchando los botones del control, cuando se ejecuta una acción, siempre estará ejecuntando las funciones de la pestaña **Controller**, las cuales verificarán si el botón correspondiente ha sido oprimido. Para evitar sobresalto, se puso una variable _buttonDelay_ para evitar que las acciones de los botones se sobrelapen.

Existe también un booleano principal que me divide la variable en dos, un _selected_ que, durante la ejecución del _draw_ me define si ejecutar acciones para mover la cámara o acciones para manipular el modelo si hay uno seleccionado.

## Desarrollo.

Se utilizan dos librerías principales:
- **Game Control Plus** para utilizar el GamePad
- **Framesjs** para crear el ambiente.

Lo primero que se hizo para verificar el funcionamiento general de los controles, fue inicializarlos y referenciarlos al nombre del control, y verificar que, efectivamente, responden como es debido, una vez esto fue configurado y verificado, nada más hay que siempre inicializar los controles cuando inicia el programa, y escribir las acciones que responden cuando una de estas acciones es ejecutada en la pestaña **Controller**

Cuando todo lo relacionados de los controles está configurado, se procede a incializar una escena con _Scene_ y un _eye_ creado a partir de _Node_ de la librería **Framesjs** y se inicializan los HashMaps y Arreglos relacionados con el id de cada uno de los modelos que se mostrarán en el ambiente.

Cada uno de estos modelos es un _Shape_ creado a partir de un _PShape_ del cual se toman las coordenadas originales de cada uno de sus vertices, qué se le sumó a estas coordenadas, las cajas que rodean cada modelo para saber su hubicación exacta a la hora de señalarlo con el puntero, las mesas que van a tener cada uno de los modelos y a cuánto se va a escalar. Luego de esto, se crean vectores que me guardarán en qué punto 

El uso de _Scene_ y _Shapes_, es que, a diferencia de solo usar _PShape_ y un modelo a secas de _P3D_, es que con _Scene_ puedo similar un ambiente 3D que puedo recorrer de varias formas gracias a los _rotate_ y _translate_ que provee _Scene_ y _Node_, que me permite simular una cámara en primera persona. Los _Shapes_, por su parte, responden al funcionamiento del _scene_ y el _eye_, por lo que se mueven en el mundo como si una persona se estuviera moviendo, y a su vez, actúan como si manipulara un modelo corriente cuando es seleccionado. Otra de las razones es que Scene provee funciones para percibir dónde me encuentro en este ambiente 3D, y saber hacia dónde apunta el puntero.

### Mirar al centro 

![centro](https://pbs.twimg.com/media/Des4mv5XcAEQ4Z0.jpg)

### Mirar a la derecha

![derecha](https://pbs.twimg.com/media/Des4qeVX4AM_Jgv.jpg)

### Mirar a la izquierda

![izquierda](https://pbs.twimg.com/media/Des4tbvX0AEYgJL.jpg) 


Cuando todo está iniciado, procedemos a dibujar con _draw_ Acá se resaltan tareas importantes que se realizaron:

- Se hace la suma del buttonDelay para retener sobrelape de botones.
- turnLights() me verificará si las luces deberán prendidas cuando se oprime el botón respectivo.
- drawGrid me dibujará el piso y las paredes de la "galería" utilizando una grilla
- Un _for_ que me dibujará cada uno de los shapes cargados con _**Shape.draw()**_, sus respectivas mesas y cajas invisibles.
- Una difurcación dada con _if_ que me cambiará el modelo del funcionamiento si un modelo está seleccionado o no
### Funciones de Cámara:
- _**cameraFunctions()**_ que, como su nombre lo indica, estará escuchando funciones relacionadas al comportamiento de la cámara. Si recién se entró aquí, se reiniciarán las variables especificas de los modelos, como digamos, cuál vertice estoy usando.
- _**pointer()**_ Función que me dibujará el puntero en pantalla dependiendo de dónde se encuentra actualmente, si no hay nada con qué interactuar, lo dibujará **blanco**, en caso contrario, me lo dibujará **rojo**. Para hacer esta percepción, cuando se inicializó el programa se crearon unas cajas invisibles basadas en las coordenadas de los respectivos modelos, y se mide con _scene.pointUnderPixel(height/2, width/2)_ para verificar si el puntero se encuentra sobre las coordenadas máximas y mínimas de un objeto interactivo. Y si se selecciona, podremos comenzar a manipularlo.

![boxes](https://pbs.twimg.com/media/Des7Vg5WsAA1EhM.jpg) 

### Funciones de modelo
- Cuando se selecciona un modelo, se igualará una variable _currentModel_ haciendo referencia al indice del modelo para poder acceder a HashMaps y arreglos que cuardan caracteristicas de este, así como al PShape y Shape en sí.
- Se obtiene el tamaño de **vertices igualados** del modelo.
- Se tiene qué vertice necesito manipular con _neededPoint_. Este se saca con modulo para que se mantenga dentro del rango del tamaño.
- Si se cambia de vertice (o se accede por primera vez al modelo), se ejecutarán acciones para colocar/cambiar un punto de referencia con respecto al vertice a cambiar. 
    -  Se calcula a partir del _neededPoint_ a cual **vertice igualado** me refiero. Por **vertice igualado** se refiere a que muchas figuras comparten más de un vertice con las mismas coordenadas, así que cuando se inicializa el programa, estos vertices se referencian como el mismo.
    -  Cuando se calcula el punto, se le añade un hijo al _PShape_ correspondiente que será una esfera color verde que me representará el origen del punto a manipular. Y _Shape_ se encargará de mostrar esta esfera de manera automática en la siguiente iteración del **draw()**
    
    ![model](https://pbs.twimg.com/media/Desw7omWAAEYC4o.jpg)

- Una vez se tiene el vertice, se hace un _if_ para bifurcar el programa de nuevo, la primera bifurcación trata de oír el control para ver si se oprime el botón correspondiente para ver si modelo se va a escalar o no.
- Si no voy a escalar nada, me entra a las opciones para interactuar con el correspondiente modelo:
    -  _rotateModel()_ me hará un _shape.rotateM()_ donde M es la coordenada correspondiente
    -  _movePoints()_ me toma el vertice seleccionado y, dependiendo del input del contról, le sumará o restará a la coordenada **X,Y o Z** de dicho vertice y se hará un set correspondiente al vertice para cambiar su dirección.
    -  _changePoint()_ me verifica si se oprimieron las flechas para ir al siguiente vertice igualado dentro del modelo.
    -  _resetPoint()_ me verifica si se oprimieron los sticks para resetear los valores de posición y rotación.
- Finalmente se verifica si el usuario decide deseleccionar el modelo con _deselectModel();_


Una ves de vuelta al camino común y corriente dentro del **_draw()_**, lo único que queda es hacer verificación de los controles restantes, como el de salir y resetear el ambiente, y todo lo relacionadó al HUD, como lo es el puntero (y su respectiva selección de modelo explicada anteriormente), y las instrucciones.

## Referencias
- Fuente de los modelos utilizados: [Models Resources](https://www.models-resource.com)
![Models](https://www.models-resource.com/resources/images/header/logo.png)
- Librería para uso del Gamepad: [Game Control Plus](http://lagers.org.uk/gamecontrol/index.html)
- Librería utilizada en clase: [Framesjs](https://github.com/VisualComputing/framesjs)
