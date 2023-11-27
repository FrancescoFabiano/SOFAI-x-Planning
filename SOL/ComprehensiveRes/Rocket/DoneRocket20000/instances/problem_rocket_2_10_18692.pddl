; Optimality lenght is (:optlen 60)
; Solution is (:solution fuelup r0 l8,load c15 r0 l8,fly r0 l8 l4,unload c15 r0 l4,fuelup r0 l4,load c7 r0 l4,fly r0 l4 l7,unload c7 r0 l7,fuelup r0 l7,load c17 r0 l7,fly r0 l7 l5,unload c17 r0 l5,fuelup r0 l5,load c12 r0 l5,fly r0 l5 l1,unload c12 r0 l1,fuelup r0 l1,load c6 r0 l1,fly r0 l1 l2,unload c6 r0 l2,fuelup r0 l2,load c2 r0 l2,fly r0 l2 l8,unload c2 r0 l8,fuelup r0 l8,load c16 r0 l8,fly r0 l8 l9,unload c16 r0 l9,fuelup r0 l9,load c19 r0 l9,fly r0 l9 l0,unload c19 r0 l0,fuelup r0 l0,load c0 r0 l0,fly r0 l0 l3,unload c0 r0 l3,fuelup r1 l3,load c13 r1 l3,fly r1 l3 l7,unload c13 r1 l7,fuelup r1 l7,load c5 r1 l7,fly r1 l7 l5,unload c5 r1 l5,fuelup r1 l5,load c14 r1 l5,fly r1 l5 l0,unload c14 r1 l0,fuelup r1 l0,load c4 r1 l0,fly r1 l0 l4,unload c4 r1 l4,fuelup r1 l4,load c11 r1 l4,fly r1 l4 l6,unload c11 r1 l6,fuelup r1 l6,load c9 r1 l6,fly r1 l6 l8,unload c9 r1 l8)
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
	(at r0 l8) (at r1 l3)
	
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
	
	(at c5 l7) (at c2 l2)
	(at c12 l5) (at c4 l0)
	(at c13 l3) (at c15 l8)
	(at c8 l6) (at c1 l1)
	(at c18 l9) (at c7 l4)
	(at c17 l7) (at c3 l3)
	(at c10 l2) (at c0 l0)
	(at c9 l6) (at c19 l9)
	(at c11 l4) (at c6 l1)
	(at c16 l8) (at c14 l5)
	  )
  (:goal (and 
	(at c18 l9) (at c12 l1)
	(at c11 l6) (at c15 l4)
	(at c13 l7) (at c9 l8)
	(at c14 l0) (at c5 l5)
	(at c3 l3) (at c10 l2)
	(at c1 l1) (at c16 l9)
	(at c6 l2) (at c4 l4)
	(at c19 l0) (at c0 l3)
	(at c8 l6) (at c2 l8)
	(at c7 l7) (at c17 l5)
	  )
  )
)
