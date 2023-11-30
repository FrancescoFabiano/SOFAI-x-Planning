; Optimality lenght is (:optlen 52)
; Solution is (:solution fuelup r0 l6,load c4 r0 l6,fly r0 l6 l5,unload c4 r0 l5,fuelup r0 l5,load c10 r0 l5,fly r0 l5 l4,unload c10 r0 l4,fuelup r0 l4,load c3 r0 l4,fly r0 l4 l3,unload c3 r0 l3,fuelup r0 l3,load c1 r0 l3,fly r0 l3 l0,unload c1 r0 l0,fuelup r0 l0,load c13 r0 l0,fly r0 l0 l2,unload c13 r0 l2,fuelup r0 l2,load c2 r0 l2,fly r0 l2 l6,unload c2 r0 l6,fuelup r1 l6,load c8 r1 l6,fly r1 l6 l5,unload c8 r1 l5,fuelup r1 l5,load c11 r1 l5,fly r1 l5 l2,unload c11 r1 l2,fuelup r1 l2,load c9 r1 l2,fly r1 l2 l3,unload c9 r1 l3,fuelup r1 l3,load c5 r1 l3,fly r1 l3 l1,unload c5 r1 l1,fuelup r1 l1,load c0 r1 l1,fly r1 l1 l0,unload c0 r1 l0,fuelup r1 l0,load c12 r1 l0,fly r1 l0 l4,unload c12 r1 l4,fuelup r1 l4,load c7 r1 l4,fly r1 l4 l6,unload c7 r1 l6)
(define (problem rocket_2_14_7)
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
	l0 l1
	l2 l3
	l4 l5
	l6   )
  (:init
	(at r0 l6) (at r1 l6)
	
	(rocket r0) (rocket r1)
	(cargo c0) (cargo c1)
	(cargo c2) (cargo c3)
	(cargo c4) (cargo c5)
	(cargo c6) (cargo c7)
	(cargo c8) (cargo c9)
	(cargo c10) (cargo c11)
	(cargo c12) (cargo c13)
	(location l0) (location l1)
	(location l2) (location l3)
	(location l4) (location l5)
	(location l6) 
	(at c5 l3) (at c13 l0)
	(at c10 l5) (at c7 l4)
	(at c6 l1) (at c2 l2)
	(at c4 l6) (at c9 l2)
	(at c8 l6) (at c0 l1)
	(at c3 l4) (at c1 l3)
	(at c12 l0) (at c11 l5)
	  )
  (:goal (and 
	(at c8 l5) (at c13 l2)
	(at c1 l0) (at c12 l4)
	(at c2 l6) (at c3 l3)
	(at c6 l1) (at c5 l1)
	(at c4 l5) (at c0 l0)
	(at c9 l3) (at c7 l6)
	(at c11 l2) (at c10 l4)
	  )
  )
)
