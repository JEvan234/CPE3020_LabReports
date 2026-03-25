// Lab Report 4: Jacob Evans

#set page(paper: "a4")
#set text(size:32pt, font: "JetBrainsMono NF")
#set raw(syntaxes: "VHDL.sublime-syntax")

= Lab04
LED Light Lab
#v(200pt)
#set text(size: 16pt)
Designer: Jacob Evans \
Class: CPE 3020 \
Term: Spring 2026 \ 
Date: 2026 - 03 - 21 \
#pagebreak()

= Design Description
This Design feeds a serialized input to the Adafruit Neopixel Light Stick in order for it to display a color in accordance to the 3 input switches input. One switch for each red, green, and blue. Despite having a white (RGBW) model, those inputs will be all set to 0.
= Component Diagram
#figure(image("assets/Lab04/Component04.svg"),
    caption: [Component Block Diagram])
= Design Block Diagram
#figure(image("assets/Lab04/Design04.svg",
    width: 70%),
    caption: [Design Block Diagram])

= State Machine Diagram
#figure(image("assets/Lab04/State04.svg"),
    caption: [State Machine Diagram])

== State Machine Bubble Diagram
#figure(image("assets/Lab04/State_Bubble.svg",
    width: 80%))


= Design Code

= Simulation Block Diagram
#figure(image("assets/Lab04/Testbench04.svg",
    width: 90%),
    caption: [Simulation Block Diagram])
= Simulation Code

= Simulation Results

= Wrapper Block Diagram

= Wrapper Code
