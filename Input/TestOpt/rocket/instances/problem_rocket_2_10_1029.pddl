; Optimality lenght is (:optlen 72)
; Solution is (:solution fuelup r0 l0,load c9 r0 l0,fly r0 l9,unload c9 r0 l9,fuelup r0 l9,load c3 r0 l9,fly r0 l4,unload c3 r0 l4,fuelup r0 l4,load c15 r0 l4,fly r0 l2,unload c15 r0 l2,fuelup r0 l2,load c0 r0 l2,fly r0 l6,unload c0 r0 l6,fuelup r0 l6,load c4 r0 l6,fly r0 l3,unload c4 r0 l3,fuelup r0 l3,load c8 r0 l3,fly r0 l7,unload c8 r0 l7,fuelup r0 l7,load c6 r0 l7,fly r0 l5,unload c6 r0 l5,fuelup r0 l5,load c11 r0 l5,fly r0 l1,unload c11 r0 l1,fuelup r0 l1,load c1 r0 l1,fly r0 l8,unload c1 r0 l8,fuelup r0 l8,load c18 r0 l8,fly r0 l0,unload c18 r0 l0,fuelup r1 l0,load c12 r1 l0,fly r1 l7,unload c12 r1 l7,fuelup r1 l7,load c17 r1 l7,fly r1 l3,unload c17 r1 l3,fuelup r1 l3,load c10 r1 l3,fly r1 l8,unload c10 r1 l8,fuelup r1 l8,load c13 r1 l8,fly r1 l2,unload c13 r1 l2,fuelup r1 l2,load c5 r1 l2,fly r1 l6,unload c5 r1 l6,fuelup r1 l6,load c19 r1 l6,fly r1 l1,unload c19 r1 l1,fuelup r1 l1,load c7 r1 l1,fly r1 l5,unload c7 r1 l5,fuelup r1 l5,load c2 r1 l5,fly r1 l0,unload c2 r1 l0)
(define (problem rocket_2_20_10)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1
	c0 c1
	c2 c3
	c4 c5
	c6 c7
	c8 c9
	c10 c11
	c12 c13
	c14 c15
	c16 c17
	c18 c19
	l0 l1
	l2 l3
	l4 l5
	l6 l7
	l8 l9
	  )
  (:init
	(at r0 l0) (at r1 l0)
	
	(rocket r0) (rocket r1)
	(cargo c0) (cargo c1)
	(cargo c2) (cargo c3)
	(cargo c4) (cargo c5)
	(cargo c6) (cargo c7)
	(cargo c8) (cargo c9)
	(cargo c10) (cargo c11)
	(cargo c12) (cargo c13)
	(cargo c14) (cargo c15)
	(cargo c16) (cargo c17)
	(cargo c18) (cargo c19)
	(location l0) (location l1)
	(location l2) (location l3)
	(location l4) (location l5)
	(location l6) (location l7)
	(location l8) (location l9)
	
	(at c4 l6) (at c5 l2)
	(at c13 l8) (at c1 l1)
	(at c16 l4) (at c3 l9)
	(at c12 l0) (at c2 l5)
	(at c6 l7) (at c8 l3)
	(at c7 l1) (at c11 l5)
	(at c15 l4) (at c10 l3)
	(at c17 l7) (at c18 l8)
	(at c14 l9) (at c9 l0)
	(at c0 l2) (at c19 l6)
	  )
  (:goal (and 
	(at c5 l6) (at c10 l8)
	(at c15 l2) (at c18 l0)
	(at c4 l3) (at c9 l9)
	(at c7 l5) (at c8 l7)
	(at c11 l1) (at c3 l4)
	(at c13 l2) (at c16 l4)
	(at c19 l1) (at c6 l5)
	(at c14 l9) (at c0 l6)
	(at c17 l3) (at c1 l8)
	(at c12 l7) (at c2 l0)
	  )
  )
)
