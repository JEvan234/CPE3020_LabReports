// Lab Reprt 2: Jacob Evans

#set page(paper: "a4")
#set text(size:32pt)
#set raw(syntaxes: "VHDL.sublime-syntax")

= Lab02
Hardware Interfacing Lab
#v(200pt)
#set text(size: 16pt)
Designer: Jacob Evans \
Class: CPE 3020 \
Term: Spring 2026 \ 
Date: 2026 - 02 - 11 \
#pagebreak()
= Design Description
The purpose of this lab is to interface the hardware with our design in such a way that a binary value provided by the 3 right switches (sw0, sw1, and sw2) can be passed through and light up the corresponding number of leds on either side provided by the pushbuttons. These systems (left and right) are able to be used at the same time. 

= Design Diagram
#figure(
  image("./assets/Lab02/Design02.svg",
  width: 110%),
  caption: [Design Block Diagram]
)
= Design Code